import { Router } from 'express';
import { SessionsController } from './sessions.controller';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { sessionIdParamSchema, bookSessionSchema, updateSessionSchema } from './sessions.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const sessionsController = withControllerLog(new SessionsController(), 'sessions');

router.use(authenticate);

router.get('/', sessionsController.listSessions);
router.post('/book', validate(bookSessionSchema), sessionsController.bookSession);
router.put('/:id', validate(updateSessionSchema), sessionsController.updateSession);
router.delete('/:id', validate(sessionIdParamSchema), sessionsController.deleteSession);

export default router;
