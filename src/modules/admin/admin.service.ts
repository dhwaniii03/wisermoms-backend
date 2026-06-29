import { prisma } from '../../config/prisma';
import { joinFullName, userNameSelect } from '../../utils/name.utils';
import { NotFoundError } from '../../utils/errors';
import { sendEmail } from '../../config/email';
import { UserRole, UserStatus, ApplicationStatus, ApplicationPriority } from '@prisma/client';

export class AdminService {
  async listUsers(filters: {
    page?: number;
    limit?: number;
    search?: string;
    role?: UserRole;
    status?: UserStatus;
  }) {
    const page = filters.page || 1;
    const limit = filters.limit || 10;
    const skip = (page - 1) * limit;

    const whereClause: any = {};

    if (filters.search) {
      whereClause.OR = [
        { first_name: { contains: filters.search, mode: 'insensitive' } },
        { middle_name: { contains: filters.search, mode: 'insensitive' } },
        { last_name: { contains: filters.search, mode: 'insensitive' } },
        { email: { contains: filters.search, mode: 'insensitive' } },
      ];
    }

    if (filters.role) {
      whereClause.role = filters.role;
    }

    if (filters.status) {
      whereClause.status = filters.status;
    }

    const [users, total] = await Promise.all([
      prisma.user.findMany({
        where: whereClause,
        select: {
          id: true,
          email: true,
          ...userNameSelect,
          phone: true,
          role: true,
          status: true,
          created_at: true,
          last_active_at: true,
        },
        skip,
        take: limit,
        orderBy: { created_at: 'desc' },
      }),
      prisma.user.count({ where: whereClause }),
    ]);

    return {
      data: users,
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async getUserById(id: string) {
    const user = await prisma.user.findUnique({
      where: { id },
      include: {
        family_profile: true,
        applications: {
          include: { program: { select: { name: true } } },
          orderBy: { last_updated_at: 'desc' },
        },
        documents: {
          orderBy: { uploaded_at: 'desc' },
        },
      },
    });

    if (!user) {
      throw new NotFoundError('User not found');
    }

    return user;
  }

  async updateUserStatus(adminId: string, id: string, status: UserStatus) {
    const user = await prisma.user.findUnique({
      where: { id },
    });

    if (!user) {
      throw new NotFoundError('User not found');
    }

    const updated = await prisma.user.update({
      where: { id },
      data: { status },
      select: {
        id: true,
        email: true,
        ...userNameSelect,
        status: true,
      },
    });

    // Create audit log
    await prisma.auditLog.create({
      data: {
        admin_id: adminId,
        action: 'update_user_status',
        target_type: 'users',
        target_id: id,
        metadata: { oldStatus: user.status, newStatus: status },
      },
    });

    return updated;
  }

  async listApplications(filters: { status?: string; program_id?: string; priority?: ApplicationPriority }) {
    const whereClause: any = {};

    if (filters.status) {
      whereClause.status = filters.status;
    }

    if (filters.program_id) {
      whereClause.program_id = filters.program_id;
    }

    if (filters.priority) {
      whereClause.priority = filters.priority;
    }

    return prisma.application.findMany({
      where: whereClause,
      include: {
        user: { select: { ...userNameSelect, email: true } },
        program: { select: { name: true, agency: true } },
        assigned_admin: { select: userNameSelect },
      },
      orderBy: [{ priority: 'desc' }, { last_updated_at: 'desc' }],
    });
  }

  async updateApplication(
    adminId: string,
    id: string,
    data: {
      status?: ApplicationStatus;
      notes?: string | null;
      priority?: ApplicationPriority;
      assigned_admin_id?: string | null;
    }
  ) {
    const existing = await prisma.application.findUnique({
      where: { id },
      include: { user: true, program: true },
    });

    if (!existing) {
      throw new NotFoundError('Application not found');
    }

    const isStatusChanged = data.status && data.status !== existing.status;
    const isNewlySubmitted = data.status === 'submitted' && existing.status !== 'submitted';

    const updatePayload: any = { ...data };
    if (isNewlySubmitted) {
      updatePayload.submitted_at = new Date();
    }

    const updated = await prisma.application.update({
      where: { id },
      data: updatePayload,
      include: { program: true, user: true, assigned_admin: { select: userNameSelect } },
    });

    // Audit log
    await prisma.auditLog.create({
      data: {
        admin_id: adminId,
        action: 'admin_update_application',
        target_type: 'applications',
        target_id: id,
        metadata: { updatedFields: Object.keys(data), newStatus: updated.status },
      },
    });

    // If status changed, notify user
    if (isStatusChanged) {
      const programName = updated.program?.name || 'Assistance Program';
      const statusTitle = `Application Status Updated: ${updated.status.replace('_', ' ').toUpperCase()}`;
      const statusMsg = `Your application for ${programName} has been updated to status: ${updated.status.replace('_', ' ')}.`;

      await prisma.notification.create({
        data: {
          user_id: updated.user_id,
          type: 'status_update',
          title: statusTitle,
          message: statusMsg,
          related_application_id: updated.id,
        },
      });

      await sendEmail({
        to: updated.user.email,
        subject: `MomPlan Application Update: ${programName}`,
        html: `<h1>Application Status Update</h1>
        <p>Hello ${joinFullName(updated.user.first_name, updated.user.middle_name, updated.user.last_name)},</p>
        <p>${statusMsg}</p>
        ${updated.notes ? `<p><strong>Admin Notes:</strong> ${updated.notes}</p>` : ''}
        <p>Please log in to your dashboard to complete any required tasks.</p>`,
      });
    }

    return updated;
  }

  async getAnalyticsOverview() {
    const [totalUsers, totalApplications, pendingReviews] = await Promise.all([
      prisma.user.count({ where: { role: 'user' } }),
      prisma.application.count(),
      prisma.application.count({ where: { status: 'under_review' } }),
    ]);

    return {
      totalUsers,
      totalApplications,
      pendingReviews,
    };
  }

  async getUsersTimeseries() {
    // 30-day new users timeseries
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const users = await prisma.user.findMany({
      where: {
        role: 'user',
        created_at: { gte: thirtyDaysAgo },
      },
      select: { created_at: true },
      orderBy: { created_at: 'asc' },
    });

    // Bucket by date string YYYY-MM-DD
    const counts: Record<string, number> = {};
    for (let i = 29; i >= 0; i--) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      const dateStr = d.toISOString().split('T')[0];
      counts[dateStr] = 0;
    }

    users.forEach((u) => {
      const dateStr = u.created_at.toISOString().split('T')[0];
      if (counts[dateStr] !== undefined) {
        counts[dateStr]++;
      }
    });

    return Object.entries(counts).map(([date, count]) => ({ date, count }));
  }

  async getApplicationsTimeseries() {
    // 30-day submissions timeseries
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const apps = await prisma.application.findMany({
      where: {
        submitted_at: { gte: thirtyDaysAgo },
      },
      select: { submitted_at: true },
      orderBy: { submitted_at: 'asc' },
    });

    const counts: Record<string, number> = {};
    for (let i = 29; i >= 0; i--) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      const dateStr = d.toISOString().split('T')[0];
      counts[dateStr] = 0;
    }

    apps.forEach((a) => {
      if (a.submitted_at) {
        const dateStr = a.submitted_at.toISOString().split('T')[0];
        if (counts[dateStr] !== undefined) {
          counts[dateStr]++;
        }
      }
    });

    return Object.entries(counts).map(([date, count]) => ({ date, count }));
  }

  async getProgramsAnalytics() {
    // benefits by program type
    const programs = await prisma.benefitProgram.groupBy({
      by: ['program_type'],
      _count: {
        id: true,
      },
    });

    return programs.map((p) => ({
      program_type: p.program_type,
      count: p._count.id,
    }));
  }

  async listAuditLogs() {
    return prisma.auditLog.findMany({
      include: {
        admin: { select: { ...userNameSelect, email: true } },
      },
      orderBy: { created_at: 'desc' },
      take: 100,
    });
  }

  async listAllPdfs() {
    return prisma.generatedPdf.findMany({
      include: {
        user: { select: { ...userNameSelect, email: true } },
        program: { select: { name: true, agency: true } },
      },
      orderBy: { generated_at: 'desc' },
    });
  }
}
