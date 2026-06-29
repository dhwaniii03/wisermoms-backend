import { Router } from 'express';
import { MothersController } from './mothers.controller';
import { authenticateOrgUser, requireOrgRole } from '../partner/partner-auth.middleware';
import { validate } from '../../middleware/validate';
import { assignCaseworkerSchema } from './mothers.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const ctrl = withControllerLog(new MothersController(), 'mothers');

router.get('/', authenticateOrgUser, ctrl.listMothers);
router.get('/caseworkers', authenticateOrgUser, requireOrgRole('admin'), ctrl.listCaseworkers);
router.get('/:id', authenticateOrgUser, ctrl.getMother);
router.patch(
  '/:id/assign-caseworker',
  authenticateOrgUser,
  requireOrgRole('admin'),
  validate(assignCaseworkerSchema),
  ctrl.assignCaseworker
);
router.patch(
  '/:id/unassign-caseworker',
  authenticateOrgUser,
  requireOrgRole('admin'),
  ctrl.unassignCaseworker
);

export default router;
