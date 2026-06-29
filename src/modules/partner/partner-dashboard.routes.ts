import { Router } from 'express';
import { PartnerCasesController } from './partner-cases.controller';
import { authenticateOrgUser } from './partner-auth.middleware';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const ctrl = withControllerLog(new PartnerCasesController(), 'partner.dashboard');

router.get('/summary', authenticateOrgUser, ctrl.getSummary);

export default router;
