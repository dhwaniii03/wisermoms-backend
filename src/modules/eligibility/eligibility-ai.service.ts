import Anthropic from '@anthropic-ai/sdk';
import { ANTHROPIC_MODEL } from '../../config/anthropic';
import { prisma } from '../../config/prisma';
import { FamilyProfile } from '@prisma/client';
import { EligibilityScanProgram, formatEstimatedBenefit } from '../programs/programs.eligibility';
import { decimalToNumber } from '../../utils/decimal.utils';

const AI_MAX_PROGRAMS = 20;
const AI_MAX_TOKENS = 4096;
const AI_TIMEOUT_MS = 60_000;

type AiExplanationResult = {
  programId: string;
  reasoning: string;
};

function parseExplanations(text: string): AiExplanationResult[] {
  try {
    const trimmed = text.trim();
    const fenced = trimmed.match(/^```(?:json)?\s*([\s\S]*?)\s*```$/i);
    const cleaned = fenced ? fenced[1].trim() : trimmed;

    const start = cleaned.indexOf('[');
    const end = cleaned.lastIndexOf(']');
    const jsonStr = start !== -1 && end > start ? cleaned.slice(start, end + 1) : cleaned;

    const parsed = JSON.parse(jsonStr);
    if (!Array.isArray(parsed)) return [];

    return parsed.filter(
      (item): item is AiExplanationResult =>
        typeof item?.programId === 'string' && typeof item?.reasoning === 'string'
    );
  } catch {
    return [];
  }
}

/**
 * Background service that generates human-readable AI explanations for
 * eligibility results after the HTTP response has already been returned.
 *
 * Designed to be called with `void` so it never blocks the HTTP lifecycle.
 * Errors are caught internally and never propagate to callers.
 *
 * Future: this class can be moved to a BullMQ worker without changing callers.
 */
export class EligibilityAIService {
  private anthropic: Anthropic;

  constructor() {
    this.anthropic = new Anthropic({
      apiKey: process.env.ANTHROPIC_API_KEY || 'placeholder',
    });
  }

  /**
   * Generates human-readable reasoning for qualified/likely_qualified programs
   * and updates the corresponding EligibilityResult rows.
   *
   * Claude NEVER changes status or confidence_score — the rules engine is the
   * source of truth for eligibility decisions.
   */
  async processAiExplanations(
    userId: string,
    programs: EligibilityScanProgram[],
    profile: FamilyProfile,
    userState: string,
    qualifiedProgramIds: string[]
  ): Promise<void> {
    const isPlaceholder =
      process.env.ANTHROPIC_API_KEY?.includes('placeholder') || !process.env.ANTHROPIC_API_KEY;

    try {
      if (!isPlaceholder && qualifiedProgramIds.length > 0) {
        const candidates = programs
          .filter((p) => qualifiedProgramIds.includes(p.id))
          .slice(0, AI_MAX_PROGRAMS);

        if (candidates.length > 0) {
          const explanations = await this.generateExplanations(profile, userState, candidates);

          for (const exp of explanations) {
            await prisma.eligibilityResult.updateMany({
              where: { user_id: userId, program_id: exp.programId },
              data: { reasoning: exp.reasoning, ai_processed: true },
            });
          }

          // Mark any qualified results that didn't get an AI explanation as processed
          const updatedIds = new Set(explanations.map((e) => e.programId));
          const missing = qualifiedProgramIds.filter((id) => !updatedIds.has(id));
          if (missing.length > 0) {
            await prisma.eligibilityResult.updateMany({
              where: { user_id: userId, program_id: { in: missing } },
              data: { ai_processed: true },
            });
          }
        }
      }

      // Mark all remaining unprocessed results (non-qualified) as done
      await prisma.eligibilityResult.updateMany({
        where: { user_id: userId, ai_processed: false },
        data: { ai_processed: true },
      });
    } catch (error) {
      console.error('[EligibilityAI] Background processing error:', error);
      // Ensure polling always terminates even on total failure
      await prisma.eligibilityResult
        .updateMany({
          where: { user_id: userId, ai_processed: false },
          data: { ai_processed: true },
        })
        .catch(() => {});
    }
  }

  private async generateExplanations(
    profile: FamilyProfile,
    state: string,
    programs: EligibilityScanProgram[]
  ): Promise<AiExplanationResult[]> {
    const monthlyIncome = decimalToNumber(profile.monthly_income);
    const profileSummary = {
      state,
      household_size: profile.household_size,
      num_children: profile.num_children,
      monthly_income: monthlyIncome,
      employment_status: profile.employment_status,
      is_pregnant: profile.is_pregnant,
      has_disability: profile.has_disability,
      housing_status: profile.housing_status,
      immigration_status: profile.immigration_status,
      health_insurance: profile.health_insurance,
    };

    const programPayloads = programs.map((p) => ({
      id: p.id,
      name: p.name,
      program_type: p.program_type,
      estimated_benefit: formatEstimatedBenefit(p),
      eligibility_summary: p.eligibility_summary,
    }));

    const prompt = [
      `Profile: ${JSON.stringify(profileSummary)}`,
      `Programs: ${JSON.stringify(programPayloads)}`,
    ].join('\n');

    const response = await Promise.race([
      this.anthropic.messages.create({
        model: ANTHROPIC_MODEL,
        max_tokens: AI_MAX_TOKENS,
        system:
          'You write short, friendly explanations for why a mom qualifies for benefit programs. Return ONLY a raw JSON array (no markdown). Each object: programId (use the id field from the program), reasoning (max 120 chars, conversational tone, explain the specific reason they qualify based on their profile). One object per program in the input. No extra keys.',
        messages: [{ role: 'user', content: prompt }],
      }),
      new Promise<never>((_, reject) =>
        setTimeout(() => reject(new Error('AI explanation timeout')), AI_TIMEOUT_MS)
      ),
    ]);

    const content = response.content[0];
    const text = content.type === 'text' ? content.text : '';
    return parseExplanations(text);
  }
}
