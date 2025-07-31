user = User.create!(
  email: "lio@gmail.com",
  password: "password",
  password_confirmation: "password"
)

project = Project.create!(
  name: "Sample Project",
  description: "This is a sample project for seeding.",
  user_id: user.id
)

task = Task.create!(
  title: "Initial Setup Task",
  description: "Set up the project environment and install dependencies.",
  due_date: Date.today + 7.days,
  priority: "High",
  status: "Todo",
  assignee_id: user.id,
  project_id: project.id,
  user_id: user.id 
)

Note.create!(
  content: "Don't forget to check the README file.",
  task_id: task.id,
  user_id: user.id
)
