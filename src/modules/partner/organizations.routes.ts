import { Router } from 'express';
import { Request, Response, NextFunction } from 'express';
import { MotherOrgEnrollmentService } from './mother-org-enrollment.service';
import { logHandler } from '../../utils/controllerLog';

const router = Router();
const svc = new MotherOrgEnrollmentService();

router.get(
  '/',
  logHandler('partner.organizations', 'listOrganizations', async (req, res, next) => {
    try {
      const state = typeof req.query.state === 'string' ? req.query.state : undefined;
      const city = typeof req.query.city === 'string' ? req.query.city : undefined;
      const county = typeof req.query.county === 'string' ? req.query.county : undefined;
      const stateFallback =
        req.query.stateFallback === 'true' || req.query.stateFallback === '1';
      const { organizations, matchLevel } = await svc.listOrganizations({
        state,
        city,
        county,
        stateFallback,
      });
      res.status(200).json({ success: true, data: organizations, meta: { matchLevel } });
    } catch (error) {
      next(error);
    }
  })
);

export default router;
