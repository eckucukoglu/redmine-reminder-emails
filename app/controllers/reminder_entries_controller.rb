class ReminderEntriesController < ApplicationController
  unloadable
  before_filter :find_project_by_project_id ,:authorize
  include ReminderEntriesHelper

  def index    
    @reminder_entries = ReminderEntry.where(project_id: @project.id)
  end

  def new    
    @reminder_entry = ReminderEntry.new

    @project_member_ids = @project.users.collect{|u| u.id}

    @useroptions = Array.new
    @project_member_ids.each do |project_member_id|
      user = User.find_by_id(project_member_id)
      name = user.firstname + " " + user.lastname
      @useroptions.push([name, project_member_id])
    end

    @project_tracker_ids = @project.trackers.collect{|u| u.id}
    @trackeroptions = Array.new
    @project_tracker_ids.each do |project_tracker_id|
      tracker = Tracker.find_by_id(project_tracker_id)
      @trackeroptions.push([l(tracker.name), project_tracker_id])
    end
  end

  def create    
    if params[:reminder][:tracker] == ""
      tracker_id = 0
    else
      tracker_id = params[:reminder][:tracker]
    end
    @reminder_entry = ReminderEntry.new(:project_id => @project.id,
                                        :tracker_id => tracker_id,
                                        :days => params[:reminder][:days],
                                        :env => Rails.env)

    if @reminder_entry.save
      @reminder_users = Array.new
      user_ids = params[:reminder][:users]
      user_ids.each do |user_id|
        unless user_id == ""
          reminder_user = ReminderUser.new(:reminder_entry_id => @reminder_entry.id,
                                           :user_id => user_id)
          @reminder_users.push(reminder_user)
        end
      end

      @reminder_users.each do |reminder_user|
        reminder_user.save
      end
      flash[:notice] = l(:reminder_set)
      forceUpdateScript
      redirect_to project_reminder_entries_path(:project_id => @project.id)
    else
      flash[:error] = l(:reminder_not_set)
      Rails.logger.info(@reminder_entry.errors.inspect)
      render new_project_reminder_entry_path(:project_id => @project.id)
    end
  end

  def destroy    
    @reminder_entry = ReminderEntry.find(params[:id])
    @status = @reminder_entry.destroy

    if @status
      @reminder_users = ReminderUser.where(reminder_entry_id: @reminder_entry.id)
      @reminder_users.each do |reminder_user|
        reminder_user.destroy
      end

      flash[:notice] = l(:reminder_removed)
      forceUpdateScript
      redirect_to project_reminder_entries_path
    else
      flash[:error] = l(:reminder_not_removed)
      render project_reminder_entries_path
    end
  end

  def send_now    
    @reminder_entry = ReminderEntry.find(params[:reminder_entry_id])

    options = {}
    options[:project] = @project.id
    options[:tracker] = @reminder_entry.tracker_id.to_i if @reminder_entry.tracker_id != 0
    options[:days] = @reminder_entry.days.to_i
    options[:users] = Array.new

    @reminder_users = ReminderUser.where(:reminder_entry_id => @reminder_entry.id)
    unless @reminder_users.length == 0
      @reminder_users.each do |reminder_user|
        options[:users].push(reminder_user.user_id)
      end
    end

    if send_reminders(options)
      flash[:notice] = l(:mail_sent)
      redirect_to project_reminder_entries_path(:project_id => @project.id)
    else
      flash[:error] = l(:mail_not_send)
      render project_reminder_entries_path
    end
  end

  private
  def forceUpdateScript
    reminder_script = File.open(Setting['plugin_reminderemails']['script_path'], "w")
    File.chmod(0775, Setting['plugin_reminderemails']['script_path'])
    reminder_script.write(generateScriptContent)
    reminder_script.close
  end

  def generateScriptContent
    content = "#!/bin/bash\n"
    content << "cd " + Rails.root.to_s + "\n"
    rake_content = Setting['plugin_reminderemails']['rake_path'] + " redmine:send_reminders "

    reminder_entries = ReminderEntry.all
    reminder_entries.each do |reminder_entry|
      content << rake_content
      content << generateReminderOptions(reminder_entry)
      content << "\n"
    end

    return content
  end

  def generateReminderOptions(reminder_entry)
    options = "project=\"" + reminder_entry.project_id.to_s + "\" "
    options << "days=\"" + reminder_entry.days.to_s + "\" "
    options << "RAILS_ENV=\"" + reminder_entry.env + "\" "
    unless reminder_entry.tracker_id == 0
      options << "tracker=\"" + reminder_entry.tracker_id.to_s + "\" "
    end

    reminder_users = ReminderUser.where(:reminder_entry_id => reminder_entry.id)
    unless reminder_users.length == 0
      options << "users=\""
      reminder_users.each do |reminder_user|
        options << reminder_user.user_id.to_s + ","
      end
      options = options[0...-1]
      options << "\""
    end

    return options
  end

  def send_reminders(options)
    Mailer.with_synched_deliveries do
      Mailer.reminders(options)
    end

    return true
  end

end
