# Redmine Reminder e-mails Plugin

This plugin provides a ui for redmine:send_reminders rake tasks that send reminder emails about assigned and active issues that are past due or due in the next specified number of days.

Since crontab configuration can be managed by only server administrators, adding/removing reminder tasks can also be done only by administrators. With the help of this plugin, even a project member can set a reminder or send an immidiate e-mails. `Reminder script` is known by both crontab and redmine, therefore without reaching server, a permitted redmine user can change this script.

Available options:
 - Tracker: tracker to watch (defaults to all trackers)
 - Days: number of days to remind about
 - Environment: defaults to production
 - Users: list of users who should be reminded (defaults to every user)

Moreover;
 - rake executive path (in case of rvm) and
 - reminder script path (created unless exists) should be set from plugin configurations.
 - reminder script also should be added to [crontab].

# Features

* This is a project module (`Reminders` in project menu) with only one permission.
* A permitted redmine user can add/remove a reminder that sends e-mail within a crontab interval, about his project.
* User can change a tracker, and select users from that project.
* Environment also can be set for production, development or test.
* User can also send an immidiate e-mails for any reminder entry.

## Installation

* Use a common Redmine [installation guide](http://www.redmine.org/projects/redmine/wiki/Plugins), then restart your Redmine web server.
```
$ cd /path/to/redmine/plugins
$ git clone https://github.com/eckucukoglu/redmine-reminder-emails reminderemails
$ rake redmine:plugins:migrate
$ <restart web server>
```

## Configuration

* Activate `Reminder entries` module in project settings
* Set `Rake path` in "Administration > Plugins > Reminder E-mails plugin configuration". This path must indicate your rake executable. You can learn its full path with `which rake`.
* Set `Reminder script path` in "Administration > Plugins > Reminder E-mails plugin configuration". This is the script file that used as a cron job. Even it does not exists, plugin will create a script at this location.
* Set `Manage reminder entries` permission from "Administration > Roles and permissions".
* Set cronjob for transmissions, after that restart cron daemon:

```
$ crontab -e
# Run reminder script at 06:00 every day.
0 6 * * * /reminder/script/path
$ /etc/init.d/cron restart
```

## Screenshots

![Plugin configuration](https://github.com/eckucukoglu/redmine-reminder-emails/blob/master/assets/images/screenshots/plugin_configuration.png?raw=true)

![Reminder list](https://github.com/eckucukoglu/redmine-reminder-emails/blob/master/assets/images/screenshots/reminder_list.png?raw=true)

![New reminder](https://github.com/eckucukoglu/redmine-reminder-emails/blob/master/assets/images/screenshots/new_reminder.png?raw=true)

## Uninstall

* First migrate plugin, then remove plugin files.
```
$ cd /path/to/redmine
$ rake redmine:plugins:migrate NAME=reminderemails VERSION=0 RAILS_ENV="production"
$ rm -rf plugins/reminderemails
```

## Contributions

* Any pull requests to fix a bug are welcome.
* For further development, contact me to be added as a collaborator.

## Compatibility

Plugin tested with `3.3.*` version of Redmine.

   [crontab]: <http://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/>
