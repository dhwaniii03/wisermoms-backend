import { Router } from 'express';
import { PartnerAnalyticsController } from './partner-analytics.controller';
import { authenticateOrgUser } from './partner-auth.middleware';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const ctrl = withControllerLog(new PartnerAnalyticsController(), 'partner.analytics');

router.get('/', authenticateOrgUser, ctrl.getAnalytics);
router.get('/caseworkers', authenticateOrgUser, ctrl.getCaseworkerCards);

export default router;
