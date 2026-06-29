import { Router } from 'express';
import { NotificationsController } from './notifications.controller';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { notificationIdParamSchema } from './notifications.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const notificationsController = withControllerLog(new NotificationsController(), 'notifications');

router.use(authenticate);

router.get('/', notificationsController.listNotifications);
router.put('/read-all', notificationsController.markAllAsRead);
router.put('/:id/read', validate(notificationIdParamSchema), notificationsController.markAsRead);
router.delete('/:id', validate(notificationIdParamSchema), notificationsController.deleteNotification);

export default router;
