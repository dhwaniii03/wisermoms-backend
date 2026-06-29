import { Request, Response, NextFunction } from 'express';
import { UserService } from './user.service';
import { UnauthorizedError } from '../../utils/errors';

const userService = new UserService();

export class UserController {
  async getProfile(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const profile = await userService.getProfile(req.user.id);
      res.status(200).json({ success: true, data: profile });
    } catch (error) {
      next(error);
    }
  }

  async updateProfile(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const profile = await userService.updateProfile(req.user.id, req.body);
      res.status(200).json({ success: true, data: profile });
    } catch (error) {
      next(error);
    }
  }

  async getFamilyProfile(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const familyProfile = await userService.getFamilyProfile(req.user.id);
      res.status(200).json({ success: true, data: familyProfile });
    } catch (error) {
      next(error);
    }
  }

  async updateFamilyProfile(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      if (!req.user) throw new UnauthorizedError();
      const familyProfile = await userService.updateFamilyProfile(req.user.id, req.body);
      res.status(200).json({ success: true, data: familyProfile });
    } catch (error) {
      next(error);
    }
  }
}
