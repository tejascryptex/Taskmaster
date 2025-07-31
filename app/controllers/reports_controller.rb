class ReportsController < ApplicationController
  def index
    tasks = Task.all

    @tasks = Task.where("assignee_id = :user_id OR project_id IN (:project_ids)", {
      user_id: current_user.id,
      project_ids: current_user.projects.pluck(:id)
    })

    @task_stats = {
      completed: tasks.where(status: "Completed").count,
      in_progress: tasks.where(status: "In Progress").count,
      not_started: tasks.where(status: "Not Started").count,
      total: tasks.count
    }

    @time_tracking = tasks.where.not(time_spent: nil).group(:assignee_id).sum(:time_spent)

    @project_progress = Project.includes(:tasks).map do |project|
      total = project.tasks.count
      completed = project.tasks.where(status: "Completed").count
      percent = total > 0 ? (completed * 100 / total) : 0

      { name: project.name, percent: percent }
    end

    # 🆕 This fixes the missing variable
    @time_spent_by_project = Project.includes(:tasks).map do |project|
      time_spent = project.tasks.sum(:time_spent)
      { name: project.name, time_spent: time_spent }
    end
  end
end
