json.extract! task, :id, :title, :description, :due_date, :priority, :status, :assignee_id, :parent_id, :project_id, :created_at, :updated_at
json.url task_url(task, format: :json)
