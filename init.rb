Redmine::Plugin.register :reminderemails do
  name 'Reminder E-mails plugin'
  url 'https://github.com/eckucukoglu/redmine-reminder-emails'
  description 'This plugin provides a configuration environment for redmine:send_reminders rake tasks.'
  author 'Emre Can Kucukoglu'
  author_url 'http://eckucukoglu.com'
  version '0.0.1'
  requires_redmine version_or_higher: '3.3.0'
end
