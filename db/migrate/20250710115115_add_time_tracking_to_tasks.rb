class AddTimeTrackingToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :started_at, :datetime
    add_column :tasks, :ended_at, :datetime
    add_column :tasks, :time_spent, :integer
  end
end
