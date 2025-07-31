class TaskReminderJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id)
    return unless task && task.reminder_at.present? && !task.reminded?

    if task.assignee
      TaskReminderMailer.reminder_email(task).deliver_now
      task.update(reminded: true)
    end
  end
end
