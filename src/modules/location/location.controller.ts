import { Request, Response, NextFunction } from 'express';
import { zipValidationService } from '../../services/zipValidation.service';

export class LocationController {
  async validateZip(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { zip, state, city, county } = req.body as {
        zip: string;
        state: string;
        city?: string;
        county?: string;
      };
      const result = await zipValidationService.validateZip(zip, state, city, county);

      res.status(200).json({
        success: true,
        data: {
          valid: result.valid,
          city: result.city ?? null,
          cities: result.cities ?? [],
          state: result.state ?? null,
          zip: result.zip ?? null,
          counties: result.counties ?? [],
          county: result.county ?? null,
          error: result.error ?? null,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  async lookupZip(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { zip } = req.body as { zip: string };
      const result = await zipValidationService.lookupZip(zip);

      res.status(200).json({
        success: true,
        data: {
          zip: result.zip,
          city: result.city,
          cities: result.cities ?? [],
          state: result.state,
          stateName: result.stateName,
          counties: result.counties,
          error: result.error ?? null,
        },
      });
    } catch (error) {
      next(error);
    }
  }

  async lookupCity(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { state, city } = req.query as { state: string; city: string };
      const result = await zipValidationService.lookupCityInState(state, city);

      res.status(200).json({
        success: true,
        data: {
          valid: result.valid,
          city: result.city,
          state: result.state,
          zips: result.zips,
          error: result.error ?? null,
        },
      });
    } catch (error) {
      next(error);
    }
  }
}
