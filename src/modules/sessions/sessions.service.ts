import { prisma } from '../../config/prisma';
import { NotFoundError, ForbiddenError, BadRequestError } from '../../utils/errors';
import { sendEmail } from '../../config/email';
import { UserRole } from '@prisma/client';
import { formatUserName, userNameSelect } from '../../utils/name.utils';

const userNameEmailSelect = { ...userNameSelect, email: true } as const;

export class SessionsService {
  async listSessions(userId: string, role: UserRole) {
    if (role === 'admin') {
      return prisma.counselorSession.findMany({
        include: {
          user: { select: userNameEmailSelect },
          counselor: { select: userNameEmailSelect },
        },
        orderBy: { scheduled_at: 'asc' },
      });
    }

    if (role === 'counselor') {
      return prisma.counselorSession.findMany({
        where: { counselor_id: userId },
        include: {
          user: { select: userNameEmailSelect },
        },
        orderBy: { scheduled_at: 'asc' },
      });
    }

    // Normal users view sessions where they are the user
    return prisma.counselorSession.findMany({
      where: { user_id: userId },
      include: {
        counselor: { select: userNameEmailSelect },
      },
      orderBy: { scheduled_at: 'asc' },
    });
  }

  async bookSession(
    userId: string,
    data: { counselor_id: string; scheduled_at: string; duration_minutes: number; notes?: string }
  ) {
    // Ensure target counselor exists and has role 'counselor' or 'admin'
    const counselor = await prisma.user.findUnique({
      where: { id: data.counselor_id },
    });

    if (!counselor || (counselor.role !== 'counselor' && counselor.role !== 'admin')) {
      throw new BadRequestError('Selected user is not an available counselor');
    }

    const user = await prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundError('User profile not found');
    }

    // Generate a real Jitsi Meet URL — fully functional, no API key required
    const roomId = `MomPlan-${counselor.id.slice(0, 8)}-${Date.now()}`;
    const meeting_url = `https://meet.jit.si/${roomId}`;

    const scheduledDate = new Date(data.scheduled_at);

    const session = await prisma.counselorSession.create({
      data: {
        user_id: userId,
        counselor_id: data.counselor_id,
        scheduled_at: scheduledDate,
        duration_minutes: data.duration_minutes,
        status: 'scheduled',
        notes: data.notes,
        meeting_url,
      },
      include: {
        counselor: { select: userNameEmailSelect },
      },
    });

    const formattedDate = scheduledDate.toLocaleDateString('en-US', {
      weekday: 'long', year: 'numeric', month: 'long', day: 'numeric',
    });
    const formattedTime = scheduledDate.toLocaleTimeString('en-US', {
      hour: '2-digit', minute: '2-digit', hour12: true,
    });

    const userName = formatUserName(user);
    const counselorName = formatUserName(session.counselor);

    // Create DB notification
    await prisma.notification.create({
      data: {
        user_id: userId,
        type: 'system',
        title: 'Counselor Session Confirmed',
        message: `Your session with ${counselorName} is scheduled for ${formattedDate} at ${formattedTime}.`,
        action_url: meeting_url,
      },
    });

    // Send confirmation email to user
    await sendEmail({
      to: user.email,
      subject: 'MomPlan: Counselor Session Confirmed',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <div style="background: linear-gradient(135deg, #6D47FC, #8B5CF6); padding: 32px; border-radius: 12px 12px 0 0; text-align: center;">
            <h1 style="color: white; margin: 0; font-size: 24px;">Session Confirmed! 🎉</h1>
          </div>
          <div style="background: white; padding: 32px; border-radius: 0 0 12px 12px; border: 1px solid #E5E7EB; border-top: none;">
            <p style="color: #374151;">Hello <strong>${userName}</strong>,</p>
            <p style="color: #374151;">Your one-on-one consultation with certified benefits advisor <strong>${counselorName}</strong> has been confirmed.</p>
            <div style="background: #F3F4F6; border-radius: 8px; padding: 20px; margin: 24px 0;">
              <p style="margin: 0 0 8px 0; color: #6B7280; font-size: 12px; text-transform: uppercase; letter-spacing: 0.05em;">Session Details</p>
              <p style="margin: 0 0 4px 0; color: #111827; font-weight: bold;">📅 ${formattedDate}</p>
              <p style="margin: 0 0 4px 0; color: #111827;">🕐 ${formattedTime} (${data.duration_minutes} minutes)</p>
              <p style="margin: 0; color: #111827;">👩‍💼 Advisor: ${counselorName}</p>
            </div>
            <div style="background: #EEF2FF; border: 1px solid #C7D2FE; border-radius: 8px; padding: 20px; margin: 24px 0;">
              <p style="margin: 0 0 12px 0; color: #4338CA; font-weight: bold;">🎥 Join Your Video Session</p>
              <p style="margin: 0 0 12px 0; color: #4B5563; font-size: 14px;">Click below to join your secure video session (no download required):</p>
              <a href="${meeting_url}" style="display: inline-block; background: #6D47FC; color: white; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: bold;">Join Video Session</a>
              <p style="margin: 12px 0 0 0; color: #6B7280; font-size: 12px;">Or copy this link: ${meeting_url}</p>
            </div>
            ${data.notes ? `<p style="color: #374151;"><strong>Your Notes:</strong> ${data.notes}</p>` : ''}
            <ul style="color: #6B7280; font-size: 14px; padding-left: 20px;">
              <li>Join 5 minutes early to test your camera and microphone</li>
              <li>Have your documents ready to discuss eligibility</li>
              <li>The video link works on any device — no app download needed</li>
            </ul>
            <p style="color: #374151; margin-top: 24px;">See you at your session!<br><strong>The MomPlan Team</strong></p>
          </div>
        </div>
      `,
    });

    // Also notify the counselor
    await sendEmail({
      to: session.counselor.email,
      subject: `MomPlan: New Session Booked — ${formattedDate} at ${formattedTime}`,
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #6D47FC;">New Session Booking</h2>
          <p>Hello <strong>${counselorName}</strong>,</p>
          <p>You have a new session booked with <strong>${userName}</strong>.</p>
          <div style="background: #F3F4F6; border-radius: 8px; padding: 20px; margin: 20px 0;">
            <p style="margin: 0 0 4px 0;"><strong>Client:</strong> ${userName} (${user.email})</p>
            <p style="margin: 0 0 4px 0;"><strong>Date:</strong> ${formattedDate}</p>
            <p style="margin: 0 0 4px 0;"><strong>Time:</strong> ${formattedTime} (${data.duration_minutes} min)</p>
            ${data.notes ? `<p style="margin: 0;"><strong>Client Notes:</strong> ${data.notes}</p>` : ''}
          </div>
          <a href="${meeting_url}" style="display: inline-block; background: #6D47FC; color: white; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: bold;">Join Session Link</a>
        </div>
      `,
    });

    return session;
  }

  async updateSession(
    id: string,
    userId: string,
    role: UserRole,
    data: { status?: string; notes?: string | null; meeting_url?: string | null; scheduled_at?: string }
  ) {
    const existing = await prisma.counselorSession.findUnique({
      where: { id },
      include: { user: true, counselor: true },
    });

    if (!existing) {
      throw new NotFoundError('Session not found');
    }

    if (role === 'user' && existing.user_id !== userId) {
      throw new ForbiddenError('Access denied');
    }

    if (role === 'counselor' && existing.counselor_id !== userId) {
      throw new ForbiddenError('Access denied');
    }

    const updatePayload: any = { ...data };
    if (data.scheduled_at) {
      updatePayload.scheduled_at = new Date(data.scheduled_at);
    }

    const updated = await prisma.counselorSession.update({
      where: { id },
      data: updatePayload,
      include: { user: true, counselor: true },
    });

    // If cancelled, send cancellation notifications
    if (data.status === 'cancelled') {
      const formattedDate = existing.scheduled_at.toLocaleDateString('en-US', {
        weekday: 'long', year: 'numeric', month: 'long', day: 'numeric',
      });
      const counselorName = formatUserName(existing.counselor);
      const userName = formatUserName(existing.user);

      await prisma.notification.create({
        data: {
          user_id: existing.user_id,
          type: 'system',
          title: 'Session Cancelled',
          message: `Your session with ${counselorName} scheduled for ${formattedDate} has been cancelled.`,
        },
      });

      await sendEmail({
        to: existing.user.email,
        subject: 'MomPlan: Session Cancelled',
        html: `<p>Hello ${userName},</p><p>Your session with ${counselorName} on <strong>${formattedDate}</strong> has been cancelled.</p><p>You can book a new session from your MomPlan dashboard.</p>`,
      });
    }

    return updated;
  }

  async deleteSession(id: string, userId: string, role: UserRole) {
    const existing = await prisma.counselorSession.findUnique({
      where: { id },
    });

    if (!existing) {
      throw new NotFoundError('Session not found');
    }

    if (role === 'user' && existing.user_id !== userId) {
      throw new ForbiddenError('Access denied');
    }

    if (role === 'counselor' && existing.counselor_id !== userId) {
      throw new ForbiddenError('Access denied');
    }

    await prisma.counselorSession.delete({
      where: { id },
    });
  }
}
