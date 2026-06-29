import { Router } from 'express';
import multer from 'multer';
import { DocumentsController } from './documents.controller';
import { authenticate, authorizeRoles } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { documentIdParamSchema, renameDocumentSchema } from './documents.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const documentsController = withControllerLog(new DocumentsController(), 'documents');

// Use memory storage to buffer files up to 10MB safely without writing to local temp paths
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB
  },
});

router.use(authenticate);

router.get('/', documentsController.listDocuments);
router.post('/upload', upload.single('file'), documentsController.uploadDocument);
router.get('/:id/download', validate(documentIdParamSchema), documentsController.downloadDocument);
router.get('/:id', validate(documentIdParamSchema), documentsController.getDocumentById);
router.delete('/:id', validate(documentIdParamSchema), documentsController.deleteDocument);

// Rename endpoint
router.patch(
  '/:id/rename',
  validate(renameDocumentSchema),
  documentsController.renameDocument
);

export default router;
