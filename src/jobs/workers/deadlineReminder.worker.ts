import { env } from '../../config/env';
import { prisma } from '../../config/prisma';
import { sendEmail } from '../../config/email';
import { formatUserName } from '../../utils/name.utils';

export const runDeadlineReminderTask = async () => {
  try {
    console.log('⏳ Running daily due-date reminder background job...');

    const now = new Date();
    // Helper to calculate target dates at midnight
    const getTargetDate = (daysAhead: number) => {
      const d = new Date();
      d.setDate(now.getDate() + daysAhead);
      d.setHours(0, 0, 0, 0);
      const end = new Date(d);
      end.setHours(23, 59, 59, 999);
      return { start: d, end };
    };

    const targetIntervals = [
      { days: 7, ...getTargetDate(7) },
      { days: 3, ...getTargetDate(3) },
      { days: 1, ...getTargetDate(1) },
    ];

    for (const interval of targetIntervals) {
      const deadlines = await prisma.deadline.findMany({
        where: {
          is_completed: false,
          due_date: {
            gte: interval.start,
            lte: interval.end,
          },
        },
        include: {
          user: true,
          application: { include: { program: true } },
        },
      });

      for (const deadline of deadlines) {
        // Create DB Notification
        const programName = deadline.application?.program?.name || 'Assistance Program';
        const msg = `Reminder: Your application due date for ${programName} (${deadline.deadline_type.replace('_', ' ')}) is in ${interval.days} day(s) on ${deadline.due_date.toLocaleDateString()}.`;

        await prisma.notification.create({
          data: {
            user_id: deadline.user_id,
            type: 'deadline',
            title: `Action Required: Due Date in ${interval.days} Day(s)`,
            message: msg,
            related_application_id: deadline.application_id,
          },
        });

        // Send Email
        await sendEmail({
          to: deadline.user.email,
          subject: `MomPlan Reminder: Due Date in ${interval.days} Day(s)`,
          html: `<h1>Upcoming Application Due Date</h1>
          <p>Hello ${formatUserName(deadline.user)},</p>
          <p>${msg}</p>
          <p>Please log into your dashboard to complete your pending tasks before the due date passes.</p>`,
        });

        // Update reminder_sent_at
        await prisma.deadline.update({
          where: { id: deadline.id },
          data: { reminder_sent_at: new Date() },
        });
      }
    }

    console.log('✅ Daily due-date reminder job finished successfully.');
  } catch (err: any) {
    console.error('❌ Due-date reminder job failed with error:', err.message);
  }
};
