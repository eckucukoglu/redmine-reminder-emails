module ReminderEntriesHelper
  def getReminderUserNames(reminder_entry_id)
    reminderUserNames = Array.new
    reminder_users = ReminderUser.where(reminder_entry_id: reminder_entry_id)
    if reminder_users != nil
      reminder_users.each do |reminder_user|
        user = User.find_by_id(reminder_user.id)
        reminderUserNames.push(user.firstname + " " + user.lastname)
      end
    end

    if reminderUserNames.length == 0
      return "Everyone"
    end
    
    return reminderUserNames
  end



end
