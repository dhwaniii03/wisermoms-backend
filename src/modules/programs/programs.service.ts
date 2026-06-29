import { prisma } from '../../config/prisma';
import { NotFoundError } from '../../utils/errors';
import { isFederalProgram, matchesProfileStateScope } from '../eligibility/eligibility.filters';
import { clearActiveProgramsCache, getActivePrograms, readProgramStateCode } from './programs.cache';
import { quarterDueDatesService } from './quarterDueDates.service';
import { getProgramRequirements, getDocumentLabel } from '../pdf/program-requirements.data';

const CATEGORY_COLORS: Record<string, string> = {
  food: 'bg-green-100 text-green-700',
  nutrition: 'bg-green-100 text-green-700',
  cash: 'bg-amber-100 text-amber-700',
  housing: 'bg-purple-100 text-purple-700',
  health: 'bg-red-100 text-red-700',
  healthcare: 'bg-red-100 text-red-700',
  childcare: 'bg-sky-100 text-sky-700',
  education: 'bg-indigo-100 text-indigo-700',
  utilities: 'bg-orange-100 text-orange-700',
  tax: 'bg-blue-100 text-blue-700',
  legal: 'bg-slate-100 text-slate-700',
};

function getCategoryColor(category: string): string {
  const key = category.toLowerCase();
  for (const [match, color] of Object.entries(CATEGORY_COLORS)) {
    if (key.includes(match)) return color;
  }
  return 'bg-slate-100 text-slate-700';
}

function getCategoryFromProgram(program: {
  program_type: string;
  tags: string[];
  eligibility_criteria: unknown;
}): string {
  const criteria = program.eligibility_criteria as Record<string, unknown> | null;
  if (criteria?.category && typeof criteria.category === 'string') {
    return criteria.category;
  }
  if (program.tags.length > 0) {
    return program.tags[0].replace(/_/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase());
  }
  return program.program_type.replace(/_/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase());
}

function getEligibilityItems(program: {
  eligibility_summary: string | null;
  eligibility_criteria: unknown;
}): string[] {
  if (program.eligibility_summary) {
    return program.eligibility_summary
      .split(/(?<=[.;])\s+/)
      .map((s) => s.trim())
      .filter(Boolean)
      .slice(0, 4);
  }

  const criteria = program.eligibility_criteria as Record<string, unknown> | null;
  if (!criteria) return [];

  return Object.entries(criteria)
    .filter(([, value]) => value !== null && value !== false)
    .map(([key, value]) => {
      const label = key.replace(/_/g, ' ');
      if (typeof value === 'boolean') return label;
      return `${label}: ${String(value)}`;
    })
    .slice(0, 4);
}

interface ChecklistProgramItem {
  id: string;
  name: string;
  shortName: string;
  category: string;
  categoryColor: string;
  level: 'Federal' | 'State';
  isFederal: boolean;
  stateCode: string | null;
  description: string;
  eligibility: string[];
  mandatoryDocs: { name: string; note?: string }[];
  optionalDocs: { name: string; note?: string }[];
  officialUrl: string;
}

let cachedChecklist: { programs: ChecklistProgramItem[]; availableStates: string[] } | null = null;
let checklistCacheTimestamp = 0;
const CACHE_TTL = 10 * 60 * 1000; // 10 minutes cache TTL

const CATEGORY_TYPE_ALIASES: Record<string, string[]> = {
  food: ['food', 'nutrition'],
  cash: ['cash'],
  housing: ['housing'],
  childcare: ['childcare'],
  healthcare: ['healthcare', 'health'],
  education: ['education'],
  utilities: ['utilities', 'energy'],
};

function matchesCategoryFilter(program: { program_type: string; tags: string[] }, category: string): boolean {
  const target = category.toLowerCase();
  const aliases = CATEGORY_TYPE_ALIASES[target] || [target];
  const programType = (program.program_type || '').toLowerCase();
  const typeMatch = aliases.some((alias) => programType.includes(alias));
  const tagMatch = (program.tags || []).some((tag) => tag.toLowerCase() === target);
  return typeMatch || tagMatch;
}

function formatBenefitLabel(program: {
  estimated_monthly_value_min: number | null;
  estimated_monthly_value_max: number | null;
}): string | null {
  const min = program.estimated_monthly_value_min;
  const max = program.estimated_monthly_value_max;
  if (min == null || max == null) return null;
  if (min === max) return `$${min}/mo`;
  return `$${min}–$${max}/mo`;
}

function mapProgramForBrowse(program: {
  id: string;
  name: string;
  agency: string;
  program_type: string;
  federal_or_state: string | null;
  state_code: string | null;
  description: string | null;
  estimated_monthly_value_min: number | null;
  estimated_monthly_value_max: number | null;
  application_url: string | null;
  agency_website: string | null;
  contact_email: string | null;
  tags: string[];
  eligibility_criteria: unknown;
}) {
  return {
    id: program.id,
    name: program.name,
    agency: program.agency,
    program_type: program.program_type,
    federal_or_state: program.federal_or_state,
    state_code: program.state_code,
    estimated_monthly_value_min: program.estimated_monthly_value_min,
    estimated_monthly_value_max: program.estimated_monthly_value_max,
    description: program.description || '',
    benefit: formatBenefitLabel(program),
    website: program.agency_website || '',
    application_url: program.application_url || '',
    contact_email: program.contact_email,
    tags: program.tags,
    eligibility_criteria: program.eligibility_criteria,
  };
}

export function clearProgramsCache() {
  clearActiveProgramsCache();
  cachedChecklist = null;
  checklistCacheTimestamp = 0;
}

export class ProgramsService {
  async listPrograms(filters: {
    state?: string;
    type?: string;
    search?: string;
    level?: string;
    page?: number;
    limit?: number;
  } = {}) {
    const cachedPrograms = await getActivePrograms();

    let filtered = cachedPrograms;
    const selectedState = filters.state && filters.state !== 'All' ? filters.state.toUpperCase() : 'All';
    const selectedLevel = filters.level || 'All levels';

    if (selectedState !== 'All') {
      filtered = filtered.filter((p) => matchesProfileStateScope(p, selectedState));
    }

    if (selectedLevel !== 'All levels') {
      filtered = filtered.filter((p) => {
        const isFederal = isFederalProgram(p);
        if (selectedLevel === 'Federal') return isFederal;
        if (selectedLevel === 'State') return !isFederal;
        return true;
      });
    }

    if (filters.type && filters.type !== 'All') {
      filtered = filtered.filter((p) => matchesCategoryFilter(p, filters.type!));
    }

    const query = (filters.search || '').trim().toLowerCase();
    if (query) {
      filtered = filtered.filter((p) => {
        const name = (p.name || '').toLowerCase();
        const description = (p.description || '').toLowerCase();
        const agency = (p.agency || '').toLowerCase();
        const alsoKnownAs = (p.also_known_as || '').toLowerCase();
        return (
          name.includes(query) ||
          description.includes(query) ||
          agency.includes(query) ||
          alsoKnownAs.includes(query)
        );
      });
    }

    const availableStates = [
      ...new Set(
        cachedPrograms
          .map((program) => readProgramStateCode(program))
          .filter(Boolean)
      ),
    ].sort();

    const total = filtered.length;
    const paginate = filters.limit !== undefined;
    const page = filters.page || 1;
    const limit = filters.limit ?? total;
    const totalPages = paginate ? Math.max(1, Math.ceil(total / limit)) : 1;
    const safePage = paginate ? Math.min(page, totalPages) : 1;
    const skip = paginate ? (safePage - 1) * limit : 0;
    const programs = filtered.slice(skip, paginate ? skip + limit : undefined).map(mapProgramForBrowse);

    return {
      programs,
      availableStates,
      total,
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

  async listDocumentsChecklist(filters: {
    state?: string;
    level?: string;
    search?: string;
    page?: number;
    limit?: number;
  } = {}) {
    const { programs: allPrograms, availableStates } = await this.getChecklistCache();
    const query = (filters.search || '').trim().toLowerCase();
    const selectedState = filters.state && filters.state !== 'All' ? filters.state.toUpperCase() : 'All';
    const selectedLevel = filters.level || 'All levels';

    const filtered = allPrograms.filter((program) => {
      const matchState =
        selectedState === 'All' ||
        program.isFederal ||
        (program.stateCode || '').toUpperCase() === selectedState;
      const matchLevel =
        selectedLevel === 'All levels' ||
        (selectedLevel === 'Federal' && program.isFederal) ||
        (selectedLevel === 'State' && !program.isFederal);
      const matchSearch =
        !query ||
        program.name.toLowerCase().includes(query) ||
        program.category.toLowerCase().includes(query) ||
        program.mandatoryDocs.some((d) => d.name.toLowerCase().includes(query)) ||
        program.optionalDocs.some((d) => d.name.toLowerCase().includes(query));

      return matchState && matchLevel && matchSearch;
    });

    const total = filtered.length;
    const paginate = filters.limit !== undefined;
    const page = filters.page || 1;
    const limit = filters.limit ?? total;
    const totalPages = paginate ? Math.max(1, Math.ceil(total / limit)) : 1;
    const safePage = paginate ? Math.min(page, totalPages) : 1;
    const skip = paginate ? (safePage - 1) * limit : 0;
    const programs = filtered.slice(skip, paginate ? skip + limit : undefined);

    return {
      programs,
      availableStates,
      total,
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

  private async getChecklistCache() {
    const now = Date.now();
    if (!cachedChecklist || now - checklistCacheTimestamp > CACHE_TTL) {
      const programs = await prisma.benefitProgram.findMany({
        where: { is_active: true },
        include: { documents_required: true },
        orderBy: { name: 'asc' },
      });

      const checklistPrograms = programs.map((program) => {
        let mandatoryDocs: { name: string; note?: string }[] = [];
        let optionalDocs: { name: string; note?: string }[] = [];

        if (program.documents_required.length > 0) {
          for (const doc of program.documents_required) {
            const item = {
              name: doc.document_name,
              ...(doc.description ? { note: doc.description } : {}),
            };
            if (doc.required) mandatoryDocs.push(item);
            else optionalDocs.push(item);
          }
        } else {
          const requirements = getProgramRequirements(program.name);
          if (requirements) {
            mandatoryDocs = requirements.required_documents.map((type) => ({
              name: getDocumentLabel(type),
            }));
            optionalDocs = requirements.optional_documents.map((type) => ({
              name: getDocumentLabel(type),
            }));
          }
        }

        const category = getCategoryFromProgram(program);

        return {
          id: program.id,
          name: program.name,
          shortName: program.also_known_as || program.name.split(/[—–-]/)[0].trim(),
          category,
          categoryColor: getCategoryColor(category),
          level: isFederalProgram(program) ? 'Federal' as const : 'State' as const,
          isFederal: isFederalProgram(program),
          stateCode: program.state_code,
          description: program.description || '',
          eligibility: getEligibilityItems(program),
          mandatoryDocs,
          optionalDocs,
          officialUrl: program.application_url || program.agency_website || '',
        };
      });

      const availableStates = [
        ...new Set(
          checklistPrograms
            .map((program) => readProgramStateCode({ state_code: program.stateCode }))
            .filter(Boolean)
        ),
      ].sort();

      cachedChecklist = { programs: checklistPrograms, availableStates };
      checklistCacheTimestamp = now;
    }

    return cachedChecklist;
  }

  async getProgramById(id: string) {
    const program = await prisma.benefitProgram.findUnique({
      where: { id },
    });

    if (!program) {
      throw new NotFoundError('Benefit program not found');
    }

    return program;
  }

  async createProgram(
    adminId: string,
    data: {
      name: string;
      agency: string;
      program_type: string;
      federal_or_state: string;
      state_code?: string | null;
      description: string;
      eligibility_criteria: any;
      estimated_monthly_value_min: number;
      estimated_monthly_value_max: number;
      application_url?: string | null;
      contact_email?: string | null;
      is_active?: boolean;
      program_due_date?: string | null;
    }
  ) {
    const insertData = {
      ...data,
      program_due_date: data.program_due_date ? new Date(data.program_due_date) : null,
    };

    const program = await prisma.benefitProgram.create({
      data: insertData,
    });

    await quarterDueDatesService.backfillProgramQuarters(program.id, new Date().getUTCFullYear());

    // Invalidate cache
    clearProgramsCache();

    // Create Audit log
    await prisma.auditLog.create({
      data: {
        admin_id: adminId,
        action: 'create_program',
        target_type: 'benefit_programs',
        target_id: program.id,
        metadata: { name: program.name },
      },
    });

    return program;
  }

  async updateProgram(adminId: string, id: string, data: any) {
    const existing = await prisma.benefitProgram.findUnique({
      where: { id },
    });

    if (!existing) {
      throw new NotFoundError('Benefit program not found');
    }

    const updateData = { ...data };
    if (updateData.program_due_date !== undefined) {
      updateData.program_due_date = updateData.program_due_date ? new Date(updateData.program_due_date) : null;
    }

    const renewalPeriodChanged =
      updateData.renewal_period_months !== undefined &&
      updateData.renewal_period_months !== existing.renewal_period_months;

    const updated = await prisma.benefitProgram.update({
      where: { id },
      data: updateData,
    });

    if (renewalPeriodChanged) {
      await quarterDueDatesService.regenerateCalculatedQuarters(id);
    }

    // Invalidate cache
    clearProgramsCache();

    await prisma.auditLog.create({
      data: {
        admin_id: adminId,
        action: 'update_program',
        target_type: 'benefit_programs',
        target_id: updated.id,
        metadata: { updatedFields: Object.keys(data) },
      },
    });

    return updated;
  }

  async deleteProgram(adminId: string, id: string) {
    const existing = await prisma.benefitProgram.findUnique({
      where: { id },
    });

    if (!existing) {
      throw new NotFoundError('Benefit program not found');
    }

    await prisma.benefitProgram.delete({
      where: { id },
    });

    // Invalidate cache
    clearProgramsCache();

    await prisma.auditLog.create({
      data: {
        admin_id: adminId,
        action: 'delete_program',
        target_type: 'benefit_programs',
        target_id: id,
        metadata: { name: existing.name },
      },
    });
  }

  async getProgramQuarterDueDates(programId: string, year?: number) {
    const program = await prisma.benefitProgram.findUnique({
      where: { id: programId },
      select: { id: true },
    });

    if (!program) {
      throw new NotFoundError('Benefit program not found');
    }

    const targetYear = year ?? new Date().getUTCFullYear();
    return quarterDueDatesService.getQuarterDueDatesForProgram(programId, targetYear);
  }

  async backfillQuarterDueDates(year?: number) {
    return quarterDueDatesService.backfillAllPrograms(year);
  }
}
