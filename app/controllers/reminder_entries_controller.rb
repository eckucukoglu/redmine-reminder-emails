class ReminderEntriesController < ApplicationController
  unloadable
  before_filter :find_project_by_project_id ,:authorize
  include ReminderEntriesHelper

  def index
    @project = Project.find(params[:project_id])
    @reminder_entries = ReminderEntry.where(project_id: @project.id)
  end

  def create

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

  def edit

  end

  def show

  end

  def update

  end

  def destroy

  end
end
