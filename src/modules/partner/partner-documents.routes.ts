import { Router } from 'express';
import { PartnerDocumentsController } from './partner-documents.controller';
import { authenticateOrgUser } from './partner-auth.middleware';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const ctrl = withControllerLog(new PartnerDocumentsController(), 'partner.documents');

router.get('/', authenticateOrgUser, ctrl.listDocuments);

export default router;
