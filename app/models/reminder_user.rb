class ReminderUser < ActiveRecord::Base
  unloadable

  validates :reminder_entry_id, :user_id, presence: true
end
