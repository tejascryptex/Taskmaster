class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
    @projects = current_user.projects
    @tasks = Task.where("assignee_id = ? OR project_id IN (?)", current_user.id, @projects.pluck(:id))
    @tasks = @tasks.where(project_id: params[:project_id]) if params[:project_id].present?
    @tasks = @tasks.where(status: params[:status]) if params[:status].present?
    @tasks = @tasks.where(priority: params[:priority]) if params[:priority].present?
  end

  def show
    @task = Task.find(params[:id])
  end


  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
  @task = Task.new(task_params)

  respond_to do |format|
    if @task.save
      # Send email if task has an assignee
      TaskMailer.task_assigned(@task).deliver_later if @task.assignee.present?

      format.html { redirect_to dashboard_index_path, notice: "Task was successfully created and assigned." }
      format.json { render :show, status: :created, location: @task }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @task.errors, status: :unprocessable_entity }
    end
  end
end


  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
  previous_assignee = @task.assignee_id

  respond_to do |format|
    if @task.update(task_params)
      # Send email if assignee changed
      if @task.assignee_id.present? && @task.assignee_id != previous_assignee
        TaskMailer.task_assigned(@task).deliver_later
      end

      format.html { redirect_to dashboard_index_path, notice: "Task was successfully updated." }
      format.json { render :show, status: :ok, location: @task }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @task.errors, status: :unprocessable_entity }
    end
  end
end


  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, status: :see_other, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def kanban
    @projects = current_user.projects
    @tasks_by_status = Task
      .where("project_id IN (:project_ids) OR assignee_id = :user_id", {
        project_ids: @projects.pluck(:id),
        user_id: current_user.id
      })
      .group_by(&:status)
  end

  def start_timer
    @task = Task.find(params[:id])
    @task.update(started_at: Time.current, ended_at: nil)
    redirect_back fallback_location: task_path(@task), notice: "Timer started."
  end

  def stop_timer
    @task = Task.find(params[:id])
    @task.update(ended_at: Time.current)
    # calculate minutes
    @task.update(time_spent: ((@task.ended_at - @task.started_at) / 60).to_i)
    redirect_back fallback_location: task_path(@task), notice: "Timer stopped."
  end



  def calendar
    @calendar_tasks = Task.where(assignee: current_user).or(Task.where(project: current_user.projects)).where.not(due_date: nil)
  end


  def update_due_date
    task = Task.find(params[:id])
    if task.update(due_date: params[:due_date])
      render json: { status: "success" }
    else
      render json: { status: "error", errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_status
    task = Task.find(params[:id])
    if task.update(status: params[:status])
      render json: { message: "Status updated successfully" }, status: :ok
    else
      render json: { error: task.errors.full_messages }, status: :unprocessable_entity
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.

    def set_task
      @task = Task.find(params[:id])
    end


    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :priority, :status, :project_id, :assignee_id, :parent_id, :reminder_at, attachments: [])
    end
end
