import { Router } from 'express';
import { PartnerAlertsController } from './partner-alerts.controller';
import { authenticateOrgUser } from './partner-auth.middleware';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const ctrl = withControllerLog(new PartnerAlertsController(), 'partner.alerts');

router.get('/summary', authenticateOrgUser, ctrl.getSummary);
router.get('/', authenticateOrgUser, ctrl.listAlerts);
router.post('/:id/snooze', authenticateOrgUser, ctrl.snoozeAlert);

export default router;
