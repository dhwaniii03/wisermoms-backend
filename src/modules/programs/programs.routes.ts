import { Router } from 'express';
import { ProgramsController } from './programs.controller';
import { authenticate, authorizeRoles } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import {
  listProgramsQuerySchema,
  listDocumentsChecklistQuerySchema,
  programIdParamSchema,
  createProgramSchema,
  updateProgramSchema,
  quarterDueDatesQuerySchema,
  backfillQuarterDueDatesSchema,
} from './programs.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const programsController = withControllerLog(new ProgramsController(), 'programs');

// Publicly readable endpoints (filterable)
router.get('/', validate(listProgramsQuerySchema), programsController.listPrograms);
router.get('/documents-checklist', validate(listDocumentsChecklistQuerySchema), programsController.listDocumentsChecklist);
router.get('/:id', validate(programIdParamSchema), programsController.getProgramById);

// Admin-only mutation endpoints
router.use(authenticate);
router.use(authorizeRoles('admin'));

router.post('/', validate(createProgramSchema), programsController.createProgram);
router.post(
  '/quarter-due-dates/backfill',
  validate(backfillQuarterDueDatesSchema),
  programsController.backfillQuarterDueDates
);
router.get(
  '/:id/quarter-due-dates',
  validate(quarterDueDatesQuerySchema),
  programsController.getProgramQuarterDueDates
);
router.put('/:id', validate(updateProgramSchema), programsController.updateProgram);
router.delete('/:id', validate(programIdParamSchema), programsController.deleteProgram);

export default router;
