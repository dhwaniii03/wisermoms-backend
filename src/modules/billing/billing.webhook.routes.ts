import { Router, raw } from 'express';
import { BillingController } from './billing.controller';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const billingController = withControllerLog(new BillingController(), 'billing');

// Webhook needs raw Buffer payload for cryptographic signature verification
router.post('/webhook', raw({ type: 'application/json' }), billingController.webhook);

export default router;
