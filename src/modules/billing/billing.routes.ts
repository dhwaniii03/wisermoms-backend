import { Router } from 'express';
import { BillingController } from './billing.controller';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { checkoutBodySchema, upgradeBodySchema } from './billing.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const billingController = withControllerLog(new BillingController(), 'billing');

// Protected authenticated routes (mounted after express.json() in app.ts)
router.use(authenticate);

router.post('/checkout', validate(checkoutBodySchema), billingController.checkout);
router.post('/activate-community', billingController.activateCommunity);
router.post('/upgrade', validate(upgradeBodySchema), billingController.upgrade);
router.post('/cancel', billingController.cancel);
router.post('/reactivate', billingController.reactivate);
router.post('/portal', billingController.portal);
router.get('/subscription', billingController.subscription);
// Backwards-compatible alias
router.get('/status', billingController.subscription);

export default router;
