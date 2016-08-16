# redmine-reminder-emails

This plugin provides a configuration environment for redmine:send_reminders rake tasks that send reminder emails about assigned and active issues that are past due or due in the next specified number of days.

Available options:
 - Tracker: id of tracker (defaults to all trackers)
 - Days: number of days to remind about
 - Environment: defaults to production
 - Users: list of users who should be reminded (defaults to every user)

Moreover;
 - rake executive path (in case of rvm) and
 - reminder script path (created unless exists) should be set from plugin configurations.
 - reminder script also should be added to [crontab].


   [crontab]: <http://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/>
