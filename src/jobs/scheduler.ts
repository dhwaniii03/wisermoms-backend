import { runDeadlineReminderTask } from './workers/deadlineReminder.worker';
import { runSubscriptionSyncTask } from './workers/subscriptionSync.worker';
import { runEligibilityRefreshTask } from './workers/eligibilityRefresh.worker';
import { runRenewalCheckTask } from './workers/renewalCheck.worker';

export const startBackgroundScheduler = async (): Promise<void> => {
  try {
    console.log('⚙️ Initializing repeatable background tasks scheduler (In-Memory JS mode)...');

    // Safe Hourly Ticks: Check every hour (3,600,000ms)
    // This avoids the 32-bit integer overflow bug (max delay is 24.8 days)
    setInterval(() => {
      const now = new Date();
      const hour = now.getHours();
      
      // Daily sync at 1:00 AM
      if (hour === 1) {
        runDeadlineReminderTask();
        runSubscriptionSyncTask();
      }

      // Weekly refresh (Mondays at 2:00 AM)
      if (now.getDay() === 1 && hour === 2) {
        runEligibilityRefreshTask();
      }

      // Monthly renewal check (1st of the month at 3:00 AM)
      if (now.getDate() === 1 && hour === 3) {
        runRenewalCheckTask();
      }
    }, 60 * 60 * 1000);

    console.log('✅ Background JS tasks scheduled successfully without Redis.');
  } catch (err: any) {
    console.error('⚠️ Failed to initialize background JS scheduler:', err.message);
  }
};
