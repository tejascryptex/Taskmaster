class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :parent, class_name: "Task", optional: true

  has_many :subtasks, class_name: "Task", foreign_key: "parent_id", dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many_attached :attachments


  after_save :schedule_reminder, if: :should_schedule_reminder?
  before_save :calculate_time_spent, if: -> { started_at.present? && ended_at_changed? }


  def schedule_reminder
    TaskReminderJob.set(wait_until: reminder_at).perform_later(self.id)
  end

  def should_schedule_reminder?
    reminder_at.present? && reminder_at.future?
  end

  def calculate_time_spent
    self.time_spent = ((ended_at - started_at) / 60).to_i if ended_at && started_at
  end
end
