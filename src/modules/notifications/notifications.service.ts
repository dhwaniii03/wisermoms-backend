import { prisma } from '../../config/prisma';
import { NotFoundError, ForbiddenError } from '../../utils/errors';

export class NotificationsService {
  async listNotifications(userId: string) {
    return prisma.notification.findMany({
      where: { user_id: userId },
      include: {
        application: { include: { program: { select: { name: true } } } },
      },
      orderBy: { created_at: 'desc' },
    });
  }

  async markAsRead(id: string, userId: string) {
    const notification = await prisma.notification.findUnique({
      where: { id },
    });

    if (!notification) {
      throw new NotFoundError('Notification not found');
    }

    if (notification.user_id !== userId) {
      throw new ForbiddenError('Access denied');
    }

    return prisma.notification.update({
      where: { id },
      data: { is_read: true },
    });
  }

  async markAllAsRead(userId: string) {
    await prisma.notification.updateMany({
      where: { user_id: userId, is_read: false },
      data: { is_read: true },
    });
  }

  async deleteNotification(id: string, userId: string) {
    const notification = await prisma.notification.findUnique({
      where: { id },
    });

    if (!notification) {
      throw new NotFoundError('Notification not found');
    }

    if (notification.user_id !== userId) {
      throw new ForbiddenError('Access denied');
    }

    await prisma.notification.delete({
      where: { id },
    });
  }
}
