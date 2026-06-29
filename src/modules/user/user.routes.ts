import { Router } from 'express';
import { UserController } from './user.controller';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { updateProfileSchema, updateFamilyProfileSchema } from './user.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const userController = withControllerLog(new UserController(), 'user');

router.use(authenticate);

router.get('/profile', userController.getProfile);
router.put('/profile', validate(updateProfileSchema), userController.updateProfile);
router.get('/family-profile', userController.getFamilyProfile);
router.put('/family-profile', validate(updateFamilyProfileSchema), userController.updateFamilyProfile);

export default router;
