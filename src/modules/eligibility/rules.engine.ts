
export interface RuleContext {
  household_size: number;
  number_of_children: number;
  children_ages: number[];
  monthly_income: number;
  annual_income?: number;
  employment_status: string;
  state: string;
  age?: number;
  pregnancy_status: boolean;
  disability_status: boolean;
  housing_status: string;
  student_status: boolean;
  citizenship_status: string;
  health_insurance?: string;
  needs_childcare?: boolean;
  monthly_rent?: number;
  eviction_risk?: boolean;
  domestic_violence?: boolean;
  chronic_illness?: boolean;
  legal_issues?: string[];
  urgency?: string;
  marital_status?: string;
  income_sources?: string[];
  preferred_language?: string;
  monthly_childcare_cost?: number;
  savings_assets?: string;
}

export interface ProgramMetadata {
  income_threshold_type?: 'very_low' | 'low' | 'moderate' | 'high';
  requires_children?: boolean;
  max_child_age?: number;
  requires_pregnancy_or_child_under_5?: boolean;
  requires_employment?: boolean;
  requires_employment_or_student?: boolean;
  requires_student_status?: boolean;
  supports_disability?: boolean;
  supports_seniors_and_disability?: boolean;
  priority_score?: number;
  requires_citizenship?: boolean;
  specific_states?: string[];
  requires_housing_instability?: boolean;
  requires_childcare_need?: boolean;
  supports_domestic_violence?: boolean;
  supports_eviction_risk?: boolean;
  requires_healthcare_gap?: boolean;
  supports_legal_aid?: boolean;
  requires_pregnancy?: boolean;
}

export class RulesEngine {
  /** Federal Poverty Level-based income limits (approximate monthly, 2024) */
  private getFPLLimit(type: string, householdSize: number): number {
    // 2024 FPL: $1,255/mo for 1 person, +$433 per additional
    const fpl1 = 1255;
    const fplIncrement = 433;
    const monthlyFPL = fpl1 + (householdSize - 1) * fplIncrement;

    switch (type) {
      case 'very_low':  return monthlyFPL * 0.5;  // 50% FPL
      case 'low':       return monthlyFPL * 1.0;  // 100% FPL
      case 'moderate':  return monthlyFPL * 2.0;  // 200% FPL
      case 'high':      return monthlyFPL * 4.0;  // 400% FPL (ACA)
      default:          return monthlyFPL * 1.3;
    }
  }

  evaluate(program: any, context: RuleContext) {
    const meta = (program.metadata || program.eligibility_criteria || {}) as ProgramMetadata;
    let score = 50;
    const reasons: string[] = [];

    // Normalize: annual_income takes precedence if monthly not set
    const monthlyIncome = context.monthly_income ||
      (context.annual_income ? context.annual_income / 12 : 0);

    // 1. Income Check (improved FPL-based)
    if (meta.income_threshold_type) {
      const limit = this.getFPLLimit(meta.income_threshold_type, context.household_size);
      if (monthlyIncome <= limit) {
        score += 25;
        reasons.push(`Income qualifies at ${meta.income_threshold_type} threshold (${Math.round((monthlyIncome / limit) * 100)}% of limit).`);
      } else if (monthlyIncome <= limit * 1.15) {
        score += 8;
        reasons.push('Income slightly above limit — may qualify with expense deductions.');
      } else {
        score -= 35;
        reasons.push(`Income exceeds the ${meta.income_threshold_type} threshold for this household size.`);
      }
    }

    // 2. Children Check
    if (meta.requires_children) {
      if (context.number_of_children > 0) {
        score += 15;
        if (meta.max_child_age) {
          const validChildren = context.children_ages.filter(age => age <= meta.max_child_age!);
          if (validChildren.length > 0) {
            score += 10;
            reasons.push(`Has ${validChildren.length} child(ren) within age limit (≤${meta.max_child_age}).`);
          } else {
            score -= 25;
            reasons.push(`Children exceed age limit of ${meta.max_child_age}.`);
          }
        } else {
          reasons.push('Household includes dependent children.');
        }
      } else {
        score -= 45;
        reasons.push('Program requires at least one child in the household.');
      }
    }

    // 3. Pregnancy / WIC
    if (meta.requires_pregnancy_or_child_under_5) {
      const hasYoungChild = context.children_ages.some(age => age < 5);
      if (context.pregnancy_status || hasYoungChild) {
        score += 30;
        reasons.push(context.pregnancy_status
          ? 'Current pregnancy status qualifies.'
          : 'Has child(ren) under age 5.');
      } else {
        score -= 55;
        reasons.push('Program requires pregnancy or children under 5.');
      }
    }

    // 3b. Pregnancy-only programs
    if (meta.requires_pregnancy) {
      if (context.pregnancy_status) {
        score += 30;
        reasons.push('Pregnancy status verified — qualifies for maternal programs.');
      } else {
        score -= 40;
        reasons.push('Program is specifically for pregnant individuals.');
      }
    }

    // 4. Employment
    if (meta.requires_employment && context.employment_status === 'unemployed') {
      score -= 20;
      reasons.push('Program typically requires active employment.');
    }

    if (meta.requires_employment_or_student) {
      if (context.employment_status !== 'unemployed' || context.student_status) {
        score += 15;
        reasons.push('Meets employment or education requirements.');
      } else {
        score -= 25;
        reasons.push('Requires employment or active student status.');
      }
    }

    // 5. Disability / Chronic illness
    if (meta.supports_disability && (context.disability_status || context.chronic_illness)) {
      score += 20;
      reasons.push('Priority given for disability or chronic illness status.');
    }

    // 6. Citizenship
    if (meta.requires_citizenship) {
      const validStatuses = ['citizen', 'eligible_non_citizen'];
      if (validStatuses.includes(context.citizenship_status)) {
        score += 10;
        reasons.push('Meets citizenship or eligible non-citizen requirement.');
      } else if (context.citizenship_status === 'daca') {
        // DACA recipients may still access some programs
        score -= 15;
        reasons.push('DACA status — eligibility varies by specific program rules.');
      } else {
        score -= 50;
        reasons.push('Program requires verified citizenship or eligible immigration status.');
      }
    }

    // 7. State-specific
    if (meta.specific_states && meta.specific_states.length > 0) {
      if (meta.specific_states.includes(context.state)) {
        score += 20;
        reasons.push(`Resident of eligible state (${context.state}).`);
      } else {
        score -= 75;
        reasons.push(`Program limited to specific states, not including ${context.state}.`);
      }
    }

    // 8. Housing instability
    if (meta.requires_housing_instability) {
      if (context.housing_status === 'homeless' || context.housing_status === 'at_risk') {
        score += 25;
        reasons.push('Housing instability priority applied.');
      } else {
        score -= 20;
        reasons.push('Program targets individuals with housing instability.');
      }
    }

    // 9. Eviction risk (urgent)
    if (meta.supports_eviction_risk && context.eviction_risk) {
      score += 30;
      reasons.push('Immediate eviction risk — priority fast-track applicable.');
    }

    // 10. Childcare need
    if (meta.requires_childcare_need) {
      if (context.needs_childcare) {
        score += 20;
        reasons.push('Childcare assistance need confirmed.');
      } else {
        score -= 15;
        reasons.push('Program specifically targets families needing childcare.');
      }
    }

    // 11. Domestic violence
    if (meta.supports_domestic_violence && context.domestic_violence) {
      score += 25;
      reasons.push('Priority support for domestic violence survivors.');
    }

    // 12. Healthcare gap
    if (meta.requires_healthcare_gap) {
      const noInsurance = !context.health_insurance || context.health_insurance === 'none';
      if (noInsurance) {
        score += 20;
        reasons.push('No current health insurance — qualifies for coverage programs.');
      } else {
        score -= 10;
        reasons.push('Currently has health insurance coverage.');
      }
    }

    // 13. Legal aid programs
    if (meta.supports_legal_aid && context.legal_issues && Array.isArray(context.legal_issues)) {
      const relevantIssues = context.legal_issues.filter(issue => issue !== 'none' && issue !== '');
      if (relevantIssues.length > 0) {
        score += 20;
        reasons.push(`Dealing with civil legal issues (${relevantIssues.join(', ')}). Qualifies for free legal aid services.`);
        
        if (context.urgency === 'emergency') {
          score += 25;
          reasons.push('Immediate crisis / emergency situation — fast-track intake priority applied.');
        } else if (context.urgency === 'urgent') {
          score += 15;
          reasons.push('Urgent situation (due date or court date within 2 weeks) — priority queue routing.');
        } else if (context.urgency === 'soon') {
          score += 5;
          reasons.push('Issue requires attention soon (within next month).');
        }
      }
    }

    // 14. Urgency priority boost
    if (context.urgency === 'emergency') {
      if (context.eviction_risk && meta.supports_eviction_risk) {
        score += 15;
        reasons.push('Emergency level eviction threat — extreme priority matching.');
      }
      if (context.domestic_violence && meta.supports_domestic_violence) {
        score += 15;
        reasons.push('Emergency level safety / domestic violence situation — immediate shelter / crisis support matching.');
      }
    }

    // Normalize
    const finalScore = Math.max(0, Math.min(100, score));
    let status: 'qualified' | 'likely_qualified' | 'check_required' | 'not_qualified' = 'check_required';
    if (finalScore >= 85) status = 'qualified';
    else if (finalScore >= 65) status = 'likely_qualified';
    else if (finalScore < 35) status = 'not_qualified';

    return { score: finalScore, status, reasoning: reasons.join(' ') };
  }
}
