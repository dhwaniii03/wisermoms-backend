import { prisma } from '../../config/prisma';

/**
 * Normalization Interface
 * Represents the standard MomPlan program schema
 */
export interface NormalizedProgram {
  external_id: string;
  name: string;
  agency: string;
  description: string;
  url: string;
  category: string;
  status: 'active' | 'inactive';
}

/**
 * Provider Interface
 * All specific agency integrations (USDA, HUD, IRS, etc.) implement this.
 */
export interface GovApiProvider {
  name: string;
  baseUrl: string;
  fetchUpdates(): Promise<any[]>;
  normalize(rawData: any): NormalizedProgram | null;
}

/**
 * Scalable Government API Integration Layer
 * Handles caching, retries, and normalization of state/federal data
 */
export class GovApiIntegrationService {
  private providers: Map<string, GovApiProvider> = new Map();
  // Simple in-memory cache for API responses to prevent rate-limiting (can be replaced by Redis)
  private cache: Map<string, { data: any; expiresAt: number }> = new Map();

  constructor() {}

  /**
   * Helper for retrying fetches without external dependencies
   */
  private async fetchWithRetry(url: string, options: RequestInit = {}, retries = 3, delay = 2000): Promise<Response> {
    for (let i = 0; i < retries; i++) {
      try {
        const res = await fetch(url, {
          ...options,
          headers: {
            'User-Agent': 'MomPlan-Integration-Agent/1.0',
            'Accept': 'application/json',
            ...(options.headers || {})
          }
        });
        if (!res.ok) {
          throw new Error(`HTTP error! status: ${res.status}`);
        }
        return res;
      } catch (error: any) {
        if (i === retries - 1) throw error;
        console.warn(`[GovApi] Retrying request to ${url} (Attempt ${i + 1}) in ${delay}ms...`);
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    }
    throw new Error('Unreachable');
  }

  /**
   * Registers a new government agency data provider
   */
  registerProvider(provider: GovApiProvider) {
    this.providers.set(provider.name, provider);
    console.log(`[GovApi] Registered provider: ${provider.name}`);
  }

  /**
   * Generic fetch method with caching support
   */
  async fetchWithCache(url: string, ttlMs = 3600000) {
    const cached = this.cache.get(url);
    if (cached && cached.expiresAt > Date.now()) {
      return cached.data;
    }

    const response = await this.fetchWithRetry(url, {}, 3, 2000);
    const data = await response.json();

    this.cache.set(url, {
      data,
      expiresAt: Date.now() + ttlMs,
    });

    return data;
  }

  /**
   * Main synchronization job handler.
   * To be called via a cron job (e.g. node-cron or Agenda).
   */
  async syncAllPrograms() {
    console.log('[GovApi] Starting synchronization of all government programs...');
    
    const results = [];
    
    for (const [name, provider] of this.providers) {
      try {
        console.log(`[GovApi] Fetching from ${name}...`);
        const rawData = await provider.fetchUpdates();
        
        let successCount = 0;
        for (const rawItem of rawData) {
          const normalized = provider.normalize(rawItem);
          
          if (normalized) {
            // Future automation hook: Check for program changes before upserting
            // Example: if status changed from inactive to active, trigger an alert queue
            
            const programData = {
              name: normalized.name,
              agency: normalized.agency,
              program_type: normalized.category,
              federal_or_state: 'federal',
              description: normalized.description,
              eligibility_criteria: {},
              estimated_monthly_value_min: 0,
              estimated_monthly_value_max: 0,
              application_url: normalized.url,
              is_active: normalized.status === 'active',
              metadata: rawItem
            };

            const existingProgram = await prisma.benefitProgram.findFirst({
              where: { name: normalized.name }
            });

            if (existingProgram) {
              await prisma.benefitProgram.update({
                where: { id: existingProgram.id },
                data: {
                  description: programData.description,
                  program_type: programData.program_type,
                  is_active: programData.is_active,
                }
              });
            } else {
              await prisma.benefitProgram.create({
                data: programData
              });
            }
            successCount++;
          }
        }
        
        results.push({ provider: name, status: 'success', synced: successCount });
      } catch (error: any) {
        console.error(`[GovApi] Failed to sync ${name}: ${error.message}`);
        results.push({ provider: name, status: 'error', error: error.message });
      }
    }
    
    console.log('[GovApi] Sync completed.', results);
    return results;
  }
}

// Export singleton instance
export const govApiIntegrationService = new GovApiIntegrationService();
