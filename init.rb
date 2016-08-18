Redmine::Plugin.register :reminderemails do
  name 'Reminder E-mails plugin'
  url 'https://github.com/eckucukoglu/redmine-reminder-emails'
  description 'This plugin provides a ui for redmine:send_reminders rake tasks
    that send reminder emails about assigned and active issues that are past
    due or due in the next specified number of days.'
  author 'Emre Can Kucukoglu'
  author_url 'http://eckucukoglu.com'
  version '0.0.1'
  requires_redmine version_or_higher: '3.3.0'

  settings({
     :partial => 'settings/reminderemails',
     :default => {
       'rake_path' => 'rake',
       'script_path' => 'redmine_due_reminder.sh'
      }
  })

  menu :project_menu, :reminder_entries, { :controller => 'reminder_entries', :action => 'index' }, :caption => :reminder_menu_title, :before => :settings, :param => :project_id

  project_module :reminder_entries do
    permission :manage_reminder_entries, :reminder_entries => [:index, :new, :create, :destroy, :send_now], :require => :member
  end
end
