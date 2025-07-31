class TaskReminderMailer < ApplicationMailer
  def reminder_email(task)
    @task = task
    mail(to: task.assignee.email, subject: "Reminder for Task: #{task.title}")
  end
end
