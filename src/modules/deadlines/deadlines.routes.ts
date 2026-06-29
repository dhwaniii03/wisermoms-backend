import { Router } from 'express';
import { DeadlinesController } from './deadlines.controller';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import {
  deadlineIdParamSchema,
  createDeadlineSchema,
  dashboardQuerySchema,
} from './deadlines.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const deadlinesController = withControllerLog(new DeadlinesController(), 'deadlines');

router.use(authenticate);

router.get('/dashboard', validate(dashboardQuerySchema), deadlinesController.getDashboard);
router.get(
  '/dashboard/submitted',
  validate(dashboardQuerySchema),
  deadlinesController.getSubmittedApplicationsDashboard
);
router.get('/', deadlinesController.listDeadlines);
router.post('/', validate(createDeadlineSchema), deadlinesController.createDeadline);
router.put('/:id/complete', validate(deadlineIdParamSchema), deadlinesController.completeDeadline);
router.delete('/:id', validate(deadlineIdParamSchema), deadlinesController.deleteDeadline);

export default router;
