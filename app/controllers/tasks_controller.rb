class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @task = Task.new
    @tasks = Task.all.order(created_at: :desc)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    # binding.irb
    if @task.save
      redirect_to root_path, notice: '新しいタスクを登録しました'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'タスクを変更しました'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'タスクを削除しました'
  end

  def sort
    @tasks =
      if params[:sort] == 'created_at'
        Task.all.order(created_at: :desc)
      elsif params[:sort] == 'deadline'
        Task.all.order(deadline: :asc)
      end

      render :index
  end

  def search
    # binding.irb
    @tasks =
    if params[:search_word].blank? && params[:search_status].blank?
      Task.all.sorted
    elsif params[:search_word].present? && params[:search_status].present?
      Task.search_sort(params[:serch_word]).status_sort(params[:search_status]).sorted
    elsif params[:search_word].present? && params[:search_status].blank?
      Task.search_sort(params[:serch_word]).sorted
    elsif params[:search_word].blank? && params[:search_status].present?
      Task.status_sort(params[:search_status]).sorted
    end

    render :index
  end

  private

  def task_params
    params.require(:task).permit(
      :name,
      :detail,
      :deadline,
      :status
    )
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
