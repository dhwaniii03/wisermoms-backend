import { Router } from 'express';
import { LocationController } from './location.controller';
import { validate } from '../../middleware/validate';
import { validateZipSchema, lookupZipSchema, lookupCitySchema } from './location.schema';
import { withControllerLog } from '../../utils/controllerLog';

const router = Router();
const locationController = withControllerLog(new LocationController(), 'location');

router.post('/validate-zip', validate(validateZipSchema), locationController.validateZip);
router.post('/lookup-zip', validate(lookupZipSchema), locationController.lookupZip);
router.get('/lookup-city', validate(lookupCitySchema), locationController.lookupCity);

export default router;
