import { env } from './env';

export const ANTHROPIC_MODEL = 'claude-sonnet-4-6';

interface ClaudeMessageResponse {
  content: Array<{ text: string }>;
}

export const callClaudeApi = async (systemPrompt: string, userPrompt: string): Promise<string> => {
  const isPlaceholder = env.ANTHROPIC_API_KEY.includes('placeholder');
  
  if (isPlaceholder) {
    console.log('⚠️ Using mocked Anthropic Claude API due to placeholder key.');
    
    if (
      systemPrompt.includes('recurring payment, renewal, certification, reporting, or filing frequency') ||
      userPrompt.includes('renewalPeriodMonths')
    ) {
      return JSON.stringify({
        renewalPeriodMonths: 1,
        confidence: 0.95,
        reasoning:
          'The page repeatedly references monthly premium payments and monthly premiums.',
      });
    }

    if (
      systemPrompt.includes('calendar years to IRS quarterly employment tax due dates') ||
      userPrompt.includes('quarterIsoDates')
    ) {
      const yearMatch = userPrompt.match(/calendar year (\d{4})/);
      const calendarYear = yearMatch ? Number(yearMatch[1]) : new Date().getUTCFullYear();
      return JSON.stringify({
        quarterIsoDates: {
          q1: `${calendarYear}-04-30`,
          q2: `${calendarYear}-07-31`,
          q3: `${calendarYear}-10-31`,
          q4: `${calendarYear + 1}-01-31`,
        },
      });
    }

    if (systemPrompt.includes('You are matching US county names')) {
      const orgCountyMatch = userPrompt.match(/Organization county:\s*\n"([^"]+)"/);
      const countiesMatch = userPrompt.match(/Available counties:\s*(\[[\s\S]*?\])\s*\n/);
      const orgCounty = orgCountyMatch?.[1] ?? '';
      const counties = countiesMatch ? (JSON.parse(countiesMatch[1]) as string[]) : [];
      const normalizedOrgCounty = orgCounty
        .trim()
        .toUpperCase()
        .replace(/\./g, '')
        .replace(/'/g, '')
        .replace(/\s+/g, ' ')
        .replace(/\s+(CITY AND BOROUGH|CENSUS AREA|BOROUGH|PARISH|COUNTY)$/i, '')
        .replace(/\bSAINT\b/g, 'ST')
        .trim();

      const exact = counties.find((county) => county === normalizedOrgCounty);
      if (exact) {
        return JSON.stringify({ match: exact, confidence: 0.99 });
      }

      const whitespaceMatch = counties.find(
        (county) => county.replace(/\s+/g, '') === normalizedOrgCounty.replace(/\s+/g, '')
      );
      if (whitespaceMatch) {
        return JSON.stringify({ match: whitespaceMatch, confidence: 0.95 });
      }

      return JSON.stringify({ match: counties[0] ?? '', confidence: 0.5 });
    }

    // Determine if this is an email draft prompt or an eligibility scan prompt
    if (systemPrompt.includes('email') || systemPrompt.includes('automated government application')) {
      return `Dear Agency Representative,

Please find the application submission for the applicant attached.

Household details have been verified, and the relevant documents are included. Please review the application for the requested program.

Thank you,
MomPlan Automations System`;
    }

    // Return mock successful match array for testing eligibility scan using real seeded IDs
    return JSON.stringify([
      {
        programId: 'tanf',
        status: 'qualified',
        confidence_score: 95,
        reasoning: 'Household income and size fall well within guidelines for temporary assistance.',
        estimated_benefit: '$400 - $900/mo'
      },
      {
        programId: 'snap',
        status: 'likely_qualified',
        confidence_score: 85,
        reasoning: 'Your household size matches the nutrition assistance criteria for your state.',
        estimated_benefit: '$180 per person/mo'
      },
      {
        programId: 'wic',
        status: 'check_required',
        confidence_score: 60,
        reasoning: 'Based on your children ages, you may qualify for WIC, but an in-person appointment is required.',
        estimated_benefit: 'Food package + formula'
      }
    ]);
  }

  const response = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': env.ANTHROPIC_API_KEY,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: ANTHROPIC_MODEL,
      max_tokens: 4000,
      system: systemPrompt,
      messages: [
        { role: 'user', content: userPrompt }
      ],
    }),
  });

  if (!response.ok) {
    const errorText = await response.text();
    console.error('❌ Anthropic API Error:', errorText);
    throw new Error(`Anthropic API call failed: ${response.statusText}`);
  }

  const data = (await response.json()) as ClaudeMessageResponse;
  return data.content[0]?.text || '[]';
};
