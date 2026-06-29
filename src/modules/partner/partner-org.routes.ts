import { Router } from 'express';
import { PartnerOrgController } from './partner-org.controller';
import { authenticateOrgUser, requireOrgRole } from './partner-auth.middleware';
import { withControllerLog } from '../../utils/controllerLog';
import { validate } from '../../middleware/validate';
import {
  partnerCompleteOnboardingSchema,
  partnerUpdateOrganizationSchema,
} from './partner-org.schema';

const router = Router();
const ctrl = withControllerLog(new PartnerOrgController(), 'partner.organization');

router.get(
  '/',
  authenticateOrgUser,
  requireOrgRole('admin'),
  ctrl.getOrganization
);
router.patch(
  '/',
  authenticateOrgUser,
  requireOrgRole('admin'),
  validate(partnerUpdateOrganizationSchema),
  ctrl.updateOrganization
);
router.post(
  '/onboarding/complete',
  authenticateOrgUser,
  validate(partnerCompleteOnboardingSchema),
  ctrl.completeOnboarding
);

export default router;
