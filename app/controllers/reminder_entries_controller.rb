class ReminderEntriesController < ApplicationController
  unloadable
  before_filter :find_project_by_project_id ,:authorize
  include ReminderEntriesHelper

  def index
    @project = Project.find(params[:project_id])
    @reminder_entries = ReminderEntry.where(project_id: @project.id)
  end

  def new
    @project = Project.find(params[:project_id])
    @reminder_entry = ReminderEntry.new

    @project_member_ids = @project.users.collect{|u| u.id}

    @useroptions = Array.new
    @project_member_ids.each do |project_member_id|
      user = User.find_by_id(project_member_id)
      name = user.firstname + " " + user.lastname
      @useroptions.push([name, project_member_id])
    end

    @envoptions = Array.new
    @envoptions.push(["Development", "development"])
    @envoptions.push(["Production", "production"])
    @envoptions.push(["Test", "test"])

    @project_tracker_ids = @project.trackers.collect{|u| u.id}
    @trackeroptions = Array.new
    @project_tracker_ids.each do |project_tracker_id|
      tracker = Tracker.find_by_id(project_tracker_id)
      @trackeroptions.push([tracker.name, project_tracker_id])
    end
  end

  def create
    @project = Project.find(params[:project_id])
    if params[:reminder][:tracker] == ""
      tracker_id = 0
    else
      tracker_id = params[:reminder][:tracker]
    end
    @reminder_entry = ReminderEntry.new(:project_id => @project.id,
                                        :tracker_id => tracker_id,
                                        :days => params[:reminder][:days],
                                        :env => params[:reminder][:env])

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
      flash[:success] = "Reminder set."
      redirect_to project_reminder_entries_path(:project_id => @project.id)
    else
      flash.now[:alert] = "Reminder couldn't set! Please check the form."
      Rails.logger.info(@reminder_entry.errors.inspect)
      render new_project_reminder_entry_path(:project_id => @project.id)
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    @reminder_entry = ReminderEntry.find(params[:id])
    @status = @reminder_entry.destroy

    if @status
      @reminder_users = ReminderUser.where(reminder_entry_id: @reminder_entry.id)
      @reminder_users.each do |reminder_user|
        reminder_user.destroy
      end

      flash[:success] = "Reminder removed."
      redirect_to project_reminder_entries_path
    else
      flash.now[:alert] = "Reminder couldn't be removed!"
      render project_reminder_entries_path
    end
  end

end
