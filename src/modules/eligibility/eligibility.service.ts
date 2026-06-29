import { randomUUID } from 'node:crypto';
import { prisma } from '../../config/prisma';
import { RulesEngine } from './rules.engine';
import { FamilyProfile } from '@prisma/client';
import {
  applyEligibilityFilters,
  computeSummary,
  EligibilityResultsFilters,
  EligibilityResultsResponse,
  getProgramStateCode,
  mergeAvailableStateCodes,
  normalizeStateCode,
} from './eligibility.filters';
import { getDistinctActiveProgramStateCodes } from '../programs/programs.cache';
import { getProgramsForEligibilityScan, EligibilityScanProgram } from '../programs/programs.eligibility';
import {
  buildQuarterDueDatesByProgramAndYear,
  getAvailableYearsFromProgramYearMap,
  getQuarterForMonth,
  getRelevantDueDateInQuarter,
  quarterDueDatesByYearToObject,
  QuarterDueDatesByProgramAndYear,
} from '../programs/quarterDueDates.service';
import { EligibilityAIService } from './eligibility-ai.service';
import { decimalToNumber } from '../../utils/decimal.utils';
import {
  computeEligibilitySyncStatus,
  serializeEligibilitySyncStatus,
} from './eligibility-sync.utils';

const eligibilityAIService = new EligibilityAIService();

export class EligibilityService {
  private static scansInProgress = new Set<string>();

  async runScan(userId: string, profileUpdates?: Record<string, unknown>) {
    if (EligibilityService.scansInProgress.has(userId)) {
      throw new Error('Eligibility scan already in progress. Please wait for it to finish.');
    }
    EligibilityService.scansInProgress.add(userId);

    try {
      if (profileUpdates && Object.keys(profileUpdates).length > 0) {
        const { UserService } = await import('../user/user.service');
        const userService = new UserService();
        await userService.updateProfile(userId, profileUpdates);
      }
      return await this.executeScan(userId);
    } finally {
      EligibilityService.scansInProgress.delete(userId);
    }
  }

  async getSyncStatus(userId: string) {
    const [user, resultCount] = await Promise.all([
      prisma.user.findUnique({
        where: { id: userId },
        select: {
          updated_at: true,
          family_profile: {
            select: { updated_at: true, last_eligibility_scan_at: true },
          },
        },
      }),
      prisma.eligibilityResult.count({ where: { user_id: userId } }),
    ]);

    if (!user) {
      throw new Error('User not found');
    }

    const status = computeEligibilitySyncStatus(
      user,
      user.family_profile,
      resultCount > 0
    );
    return serializeEligibilitySyncStatus(status);
  }

  private async executeScan(userId: string) {
    // 1. Get user profile
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: { family_profile: true },
    });

    if (!user || !user.family_profile) {
      throw new Error('User profile not found. Please complete your profile first.');
    }

    const profile = user.family_profile;
    const monthlyIncome = decimalToNumber(profile.monthly_income);
    const userState = user.state || profile.state || 'GA';

    // 2. Active programs scoped to user state + federal (DB-filtered)
    const programs = await getProgramsForEligibilityScan(userState);

    // 3. Run deterministic rules engine — this is the source of truth for eligibility
    const rulesEngine = new RulesEngine();
    const ruleResults = programs.map((p) => {
      const evaluation = rulesEngine.evaluate(p, {
        household_size: profile.household_size ?? 1,
        number_of_children: profile.num_children ?? 0,
        children_ages: Array.isArray(profile.children_ages) ? (profile.children_ages as number[]) : [],
        monthly_income: monthlyIncome,
        employment_status: profile.employment_status ?? 'unemployed',
        state: userState,
        pregnancy_status: profile.is_pregnant ?? false,
        disability_status: profile.has_disability ?? false,
        housing_status: profile.housing_status ?? 'stable',
        student_status: profile.employment_status === 'student',
        citizenship_status:
          profile.immigration_status === 'citizen' ||
          profile.immigration_status === 'eligible_non_citizen'
            ? profile.immigration_status
            : 'citizen',
        needs_childcare: profile.needs_childcare ?? undefined,
        monthly_rent: profile.monthly_rent ? Number(profile.monthly_rent) : undefined,
        eviction_risk: profile.eviction_risk ?? undefined,
        domestic_violence: profile.domestic_violence ?? undefined,
        chronic_illness: profile.chronic_illness ?? undefined,
        preferred_language: profile.preferred_language || undefined,
        marital_status: profile.marital_status || undefined,
        income_sources: (profile.income_sources as string[]) || undefined,
        health_insurance: profile.health_insurance || undefined,
        savings_assets: profile.savings_assets || undefined,
        monthly_childcare_cost: profile.monthly_childcare_cost
          ? Number(profile.monthly_childcare_cost)
          : undefined,
        legal_issues:
          profile.legal_issues && Array.isArray(profile.legal_issues)
            ? (profile.legal_issues as string[])
            : [],
        urgency: profile.urgency || undefined,
      });
      return { programId: p.id, ...evaluation };
    });

    // 4. Build result rows from rules engine data — save immediately with ai_processed=false
    const programById = new Map(programs.map((p) => [p.id, p]));
    const resultIdsByProgramId = new Map<string, string>();

    const eligibilityRows = ruleResults
      .map((res) => {
        const program = programById.get(res.programId);
        if (!program) return null;
        const id = randomUUID();
        resultIdsByProgramId.set(program.id, id);
        return {
          id,
          user_id: userId,
          program_id: program.id,
          status: res.status,
          confidence_score: res.score,
          reasoning: res.reasoning,
          ai_processed: false,
        };
      })
      .filter((row): row is NonNullable<typeof row> => row !== null);

    // 5. Replace prior results atomically and stamp the profile scan time so
    // stale detection stays accurate even when profile fields were just updated.
    const scannedAt = new Date();
    await prisma.$transaction(async (tx) => {
      await tx.eligibilityResult.deleteMany({ where: { user_id: userId } });
      if (eligibilityRows.length > 0) {
        await tx.eligibilityResult.createMany({
          data: eligibilityRows.map((row) => ({ ...row, checked_at: scannedAt })),
        });
      }
      await tx.familyProfile.update({
        where: { user_id: userId },
        data: { last_eligibility_scan_at: scannedAt },
      });
    });

    // 6. Fire-and-forget: AI explanation generation happens after response is sent
    const qualifiedProgramIds = ruleResults
      .filter((r) => r.status === 'qualified' || r.status === 'likely_qualified')
      .map((r) => r.programId);

    void eligibilityAIService
      .processAiExplanations(userId, programs, profile, userState, qualifiedProgramIds)
      .catch((err) => console.error('[EligibilityService] AI background job error:', err));

    // 7. Save scan-complete notification (non-blocking)
    const qualifiedCount = ruleResults.filter(
      (r) => r.status === 'qualified' || r.status === 'likely_qualified'
    ).length;

    prisma.notification
      .create({
        data: {
          user_id: userId,
          type: 'status_update',
          title: '🎯 Eligibility Scan Complete',
          message: `Scan complete: ${qualifiedCount} program${qualifiedCount !== 1 ? 's' : ''} matched out of ${ruleResults.length} checked. View your Benefits page for details.`,
        },
      })
      .catch(() => {});

    const profileState =
      normalizeStateCode(user.state) ?? normalizeStateCode(profile.state);

    const scanResults = this.buildScanResultsFromMemory(
      ruleResults.map((r) => ({
        programId: r.programId,
        status: r.status,
        confidence_score: r.score,
        reasoning: r.reasoning,
        ai_processed: false,
      })),
      programs,
      userId,
      resultIdsByProgramId,
      profileState
    );

    return {
      results: scanResults,
      aiStatus: 'processing' as const,
    };
  }

  private buildScanResultsFromMemory(
    parsedResults: Array<{
      programId: string;
      status: string;
      confidence_score?: number;
      reasoning?: string;
      ai_processed?: boolean;
    }>,
    programs: EligibilityScanProgram[],
    userId: string,
    resultIdsByProgramId: Map<string, string>,
    profileState?: string
  ) {
    const programById = new Map(programs.map((p) => [p.id, p]));
    const checkedAt = new Date();

    const results = parsedResults
      .map((res) => {
        const program = programById.get(res.programId);
        if (!program) return null;

        return {
          id: resultIdsByProgramId.get(program.id) ?? randomUUID(),
          user_id: userId,
          program_id: program.id,
          status: res.status,
          confidence_score: res.confidence_score || 0,
          reasoning: res.reasoning ?? '',
          ai_processed: res.ai_processed ?? false,
          checked_at: checkedAt,
          program,
        };
      })
      .filter((row): row is NonNullable<typeof row> => row !== null)
      .sort((a, b) => b.confidence_score - a.confidence_score);

    const filtered = profileState
      ? applyEligibilityFilters(results, { profileState })
      : results;

    const emptyQuarterMap: QuarterDueDatesByProgramAndYear = new Map();
    return this.enrichResultsWithQuarterDueDates(filtered, emptyQuarterMap);
  }

  async getResults(
    userId: string,
    filters?: EligibilityResultsFilters
  ): Promise<EligibilityResultsResponse> {
    const [results, user] = await Promise.all([
      prisma.eligibilityResult.findMany({
        where: { user_id: userId },
        include: { program: true },
        orderBy: { confidence_score: 'desc' },
      }),
      prisma.user.findUnique({
        where: { id: userId },
        include: { family_profile: true },
      }),
    ]);

    const profileState =
      normalizeStateCode(user?.state) ?? normalizeStateCode(user?.family_profile?.state);

    const filtersWithProfile: EligibilityResultsFilters = {
      ...filters,
      ...(filters?.state || filters?.allStates ? {} : { profileState }),
    };

    const programIds = results.map((result) => result.program_id);

    const [quarterRecords, programStateCodes] = await Promise.all([
      programIds.length > 0
        ? prisma.programQuarterDueDate.findMany({
            where: { program_id: { in: programIds } },
            select: {
              program_id: true,
              year: true,
              quarter: true,
              due_dates_json: true,
            },
          })
        : Promise.resolve([]),
      getDistinctActiveProgramStateCodes(),
    ]);

    const quarterDueDatesByProgramAndYear =
      buildQuarterDueDatesByProgramAndYear(quarterRecords);
    const availableYears = getAvailableYearsFromProgramYearMap(quarterDueDatesByProgramAndYear);

    const filtered = applyEligibilityFilters(
      results,
      filtersWithProfile,
      quarterDueDatesByProgramAndYear
    );

    const enrichedResults = this.enrichResultsWithQuarterDueDates(
      filtered,
      quarterDueDatesByProgramAndYear
    );

    const availableStates = mergeAvailableStateCodes(
      programStateCodes,
      results.map((result) => getProgramStateCode(result.program)),
      profileState ? [profileState] : []
    );

    const summary = computeSummary(filtered);

    const total = enrichedResults.length;
    const paginate = filters?.limit !== undefined;
    const page = filters?.page || 1;
    const limit = filters?.limit ?? total;
    const totalPages = paginate ? Math.max(1, Math.ceil(total / limit)) : 1;
    const safePage = paginate ? Math.min(page, totalPages) : 1;
    const skip = paginate ? (safePage - 1) * limit : 0;
    const paginatedResults = enrichedResults.slice(
      skip,
      paginate ? skip + limit : undefined
    );

    // True if any result is still waiting for background AI explanations
    const aiProcessing = results.some((r) => !r.ai_processed);

    const syncStatus = computeEligibilitySyncStatus(
      user ?? { updated_at: new Date(0) },
      user?.family_profile,
      results.length > 0
    );

    return {
      results: paginatedResults,
      summary,
      scanTotalCount: results.length,
      availableStates,
      availableYears,
      profileState: profileState ?? null,
      aiProcessing,
      sync: serializeEligibilitySyncStatus(syncStatus),
      ...(paginate
        ? {
            pagination: {
              page: safePage,
              limit,
              total,
              totalPages,
            },
          }
        : {}),
    };
  }

  async getResultByProgramId(userId: string, programId: string) {
    const result = await prisma.eligibilityResult.findUnique({
      where: {
        user_id_program_id: {
          user_id: userId,
          program_id: programId,
        },
      },
      include: { program: true },
    });

    if (!result) return null;

    const quarterRecords = await prisma.programQuarterDueDate.findMany({
      where: { program_id: programId },
      select: {
        program_id: true,
        year: true,
        quarter: true,
        due_dates_json: true,
      },
    });
    const quarterDueDatesByProgramAndYear =
      buildQuarterDueDatesByProgramAndYear(quarterRecords);
    const [enriched] = this.enrichResultsWithQuarterDueDates(
      [result],
      quarterDueDatesByProgramAndYear
    );
    return enriched;
  }

  private enrichResultsWithQuarterDueDates<
    T extends { program: { id: string } | null }
  >(
    results: T[],
    quarterDueDatesByProgramAndYear: QuarterDueDatesByProgramAndYear
  ) {
    const referenceDate = new Date();
    const year = referenceDate.getUTCFullYear();
    const currentQuarter = getQuarterForMonth(referenceDate.getUTCMonth() + 1);

    return results.map((result) => {
      if (!result.program) return result;

      const yearMap = quarterDueDatesByProgramAndYear.get(result.program.id);
      const quarterDueDatesByYear = quarterDueDatesByYearToObject(yearMap);
      const currentYearQuarters = yearMap?.get(year) ?? {};
      const currentQuarterDates = currentYearQuarters[currentQuarter] ?? [];

      return {
        ...result,
        program: {
          ...result.program,
          current_quarter: currentQuarter,
          current_quarter_due_date: getRelevantDueDateInQuarter(
            currentQuarterDates,
            referenceDate
          ),
          quarter_due_dates: currentYearQuarters,
          quarter_due_dates_by_year: quarterDueDatesByYear,
        },
      };
    });
  }
}
