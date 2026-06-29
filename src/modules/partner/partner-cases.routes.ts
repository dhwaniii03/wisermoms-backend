import { Router } from 'express';
import { PartnerCasesController } from './partner-cases.controller';
import { authenticateOrgUser } from './partner-auth.middleware';
import { validate } from '../../middleware/validate';
import { createPartnerCaseSchema } from './partner-cases.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const ctrl = withControllerLog(new PartnerCasesController(), 'partner.cases');

router.post('/', authenticateOrgUser, validate(createPartnerCaseSchema), ctrl.createCase);
router.get('/', authenticateOrgUser, ctrl.listCases);
router.get('/filters', authenticateOrgUser, ctrl.getFilters);
router.get('/:id', authenticateOrgUser, ctrl.getCase);
router.post('/:id/reminder', authenticateOrgUser, ctrl.sendReminder);

export default router;
