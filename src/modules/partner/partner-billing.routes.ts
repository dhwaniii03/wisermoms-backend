import { Router } from 'express';
import { PartnerBillingController } from './partner-billing.controller';
import { authenticateOrgUser } from './partner-auth.middleware';
import { validate } from '../../middleware/validate';
import { checkoutBodySchema, downgradeBodySchema, upgradeBodySchema } from '../billing/billing.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const partnerBillingController = withControllerLog(new PartnerBillingController(), 'partner-billing');

router.use(authenticateOrgUser);

router.post('/checkout', validate(checkoutBodySchema), partnerBillingController.checkout);
router.post('/activate-community', partnerBillingController.activateCommunity);
router.post('/upgrade', validate(upgradeBodySchema), partnerBillingController.upgrade);
router.post('/downgrade', validate(downgradeBodySchema), partnerBillingController.downgrade);
router.post('/cancel', partnerBillingController.cancel);
router.post('/reactivate', partnerBillingController.reactivate);
router.post('/portal', partnerBillingController.portal);
router.get('/subscription', partnerBillingController.subscription);

export default router;
