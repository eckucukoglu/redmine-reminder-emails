class ReminderEntry < ActiveRecord::Base
  unloadable

  validates :project_id, :tracker_id, :days, :env, presence: true
end
