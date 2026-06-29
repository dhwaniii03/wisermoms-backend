import { Router } from 'express';
import { AdminController } from './admin.controller';
import { authenticate, authorizeRoles } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import {
  listUsersQuerySchema,
  userIdParamSchema,
  updateUserStatusSchema,
  listAdminApplicationsQuerySchema,
  updateAdminApplicationSchema,
} from './admin.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const adminController = withControllerLog(new AdminController(), 'admin');

router.use(authenticate);
router.use(authorizeRoles('admin'));

// Analytics overview & charts
router.get('/analytics/overview', adminController.getAnalyticsOverview);
router.get('/analytics/users', adminController.getUsersTimeseries);
router.get('/analytics/applications', adminController.getApplicationsTimeseries);
router.get('/analytics/programs', adminController.getProgramsAnalytics);

// Audit logs
router.get('/audit-logs', adminController.listAuditLogs);

// Users management
router.get('/users', validate(listUsersQuerySchema), adminController.listUsers);
router.get('/users/:id', validate(userIdParamSchema), adminController.getUserById);
router.put('/users/:id/status', validate(updateUserStatusSchema), adminController.updateUserStatus);

// Applications management
router.get('/applications', validate(listAdminApplicationsQuerySchema), adminController.listApplications);
router.put('/applications/:id', validate(updateAdminApplicationSchema), adminController.updateApplication);

// Generated PDFs tracking
router.get('/pdfs', adminController.listPdfs);
router.get('/pdfs/:id/download', adminController.downloadPdf);

export default router;
