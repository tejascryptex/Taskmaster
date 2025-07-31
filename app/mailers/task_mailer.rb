class TaskMailer < ApplicationMailer
  def task_assigned(task)
    @task = task
    @user = task.assignee
    mail(to: @user.email, subject: "New Task Assigned: #{@task.title}")
  end
end
