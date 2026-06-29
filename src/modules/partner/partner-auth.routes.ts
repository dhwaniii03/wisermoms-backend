import { Router } from 'express';
import { PartnerAuthController } from './partner-auth.controller';
import { validate } from '../../middleware/validate';
import { authLimiter } from '../../middleware/rateLimiter';
import {
  partnerRegisterSchema,
  partnerLoginSchema,
  partnerRefreshSchema,
  partnerChangePasswordSchema,
} from './partner-auth.schema';
import { authenticateOrgUser } from './partner-auth.middleware';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const ctrl = withControllerLog(new PartnerAuthController(), 'partner.auth');

router.post('/register', authLimiter, validate(partnerRegisterSchema), ctrl.register);
router.post('/login',    authLimiter, validate(partnerLoginSchema),    ctrl.login);
router.post('/logout',   ctrl.logout);
router.post('/refresh',  validate(partnerRefreshSchema),               ctrl.refresh);
router.post('/change-password', authenticateOrgUser, validate(partnerChangePasswordSchema), ctrl.changePassword);

export default router;
