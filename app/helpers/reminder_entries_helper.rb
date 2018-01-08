module ReminderEntriesHelper
  def getReminderUserNames(reminder_entry_id)
    reminderUserNames = Array.new
    reminder_users = ReminderUser.where(reminder_entry_id: reminder_entry_id)
    if reminder_users != nil
      reminder_users.each do |reminder_user|
        user = User.find_by_id(reminder_user.user_id)
        if user != nil
          reminderUserNames.push(user.firstname + " " + user.lastname)
        else
          reminderUserNames.push("#" + reminder_user.user_id.to_s)
        end
      end
    end

    if reminderUserNames.length == 0
      return l(:user_all)
    end

    return reminderUserNames
  end

  def getReminderTrackerName(tracker_id)
    tracker_id == 0 ? l(:tracker_all) : Tracker.find(tracker_id).name
  rescue ActiveRecord::RecordNotFound
    "##{tracker_id}"
  end

end
