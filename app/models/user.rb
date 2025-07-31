class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assignee_id"
  has_many :notes, dependent: :destroy


  after_create :send_welcome_email

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
