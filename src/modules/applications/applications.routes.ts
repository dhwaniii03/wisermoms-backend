import { Router } from 'express';
import { ApplicationsController } from './applications.controller';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import {
  listApplicationsQuerySchema,
  applicationIdParamSchema,
  createApplicationSchema,
  updateApplicationSchema,
  applyApplicationSchema,
} from './applications.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const applicationsController = withControllerLog(new ApplicationsController(), 'applications');

router.use(authenticate);

router.get('/', validate(listApplicationsQuerySchema), applicationsController.listApplications);
router.post('/', validate(createApplicationSchema), applicationsController.createApplication);
router.get('/:id', validate(applicationIdParamSchema), applicationsController.getApplicationById);
router.put('/:id', validate(updateApplicationSchema), applicationsController.updateApplication);
router.delete('/:id', validate(applicationIdParamSchema), applicationsController.deleteApplication);

// Generate Draft without submitting
router.get('/:id/draft', validate(applicationIdParamSchema), applicationsController.generateDraft);

// Submit application (can include edited draft)
router.post('/:id/apply', validate(applyApplicationSchema), applicationsController.applyApplication);

export default router;
