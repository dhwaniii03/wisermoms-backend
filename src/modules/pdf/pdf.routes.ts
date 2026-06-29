import { Router } from 'express';
import { PdfController } from './pdf.controller';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { generatePdfSchema, validatePdfSchema, pdfIdParamSchema, listPdfsQuerySchema, pdfStreamQuerySchema } from './pdf.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const pdfController = withControllerLog(new PdfController(), 'pdf');

router.use(authenticate);

router.post('/validate', validate(validatePdfSchema), pdfController.validateForProgram);
router.post('/generate', validate(generatePdfSchema), pdfController.generatePdf);
router.get('/', validate(listPdfsQuerySchema), pdfController.listPdfs);
router.get('/:id/download', validate(pdfIdParamSchema), pdfController.downloadPdf);
router.get('/:id/download/stream', validate(pdfStreamQuerySchema), pdfController.streamLocalPdf);
router.post('/:id/sync-vault', validate(pdfIdParamSchema), pdfController.syncVaultDocument);
router.delete('/:id', validate(pdfIdParamSchema), pdfController.deletePdf);

export default router;
