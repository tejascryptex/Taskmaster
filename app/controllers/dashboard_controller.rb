class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = current_user.projects.includes(:tasks)

    #  all tasks from user's projects
    tasks = Task.where(project_id: @projects.pluck(:id))

    # Filter by priority if param is present and valid
    if params[:priority].present? && params[:priority] != "All"
      tasks = tasks.where(priority: params[:priority])
    end

    # Group tasks by status for Kanban board
    @tasks_by_status = tasks.group_by(&:status)

    # Calendar events (tasks with due dates)
    @calendar_tasks = tasks.select { |t| t.due_date.present? }
  end
end
