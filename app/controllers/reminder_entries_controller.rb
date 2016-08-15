class ReminderEntriesController < ApplicationController
  unloadable
  before_filter :find_project_by_project_id ,:authorize
  include ReminderEntriesHelper

  def index
    @project = Project.find(params[:project_id])
  end

  def create

  end

  def new

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
