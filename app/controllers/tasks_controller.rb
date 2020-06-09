class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :not_logged_in

  def index
    # binding.irb
    @tasks = current_user.tasks.sorted.kaminari(params[:page])
    @labels = Label.where(user_id: nil).or(Label.where(user_id: current_user.id))
  end

  def new
    @task = Task.new
    @label = @task.labelings.build
    @labels = Label.where(user_id: nil).or(Label.where(user_id: current_user.id))
  end

  def create
    @task = current_user.tasks.build(task_params)
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
    @labels = Label.where(user_id: nil).or(Label.where(user_id: current_user.id))
  end

  def update
    if @task.update(task_params)
      redirect_to root_path, notice: 'タスクを変更しました'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'タスクを削除しました'
  end

  def search
    session[:search] = {'word' => params[:search_word], 'status' => params[:search_status], 'priority' => params[:search_priority], 'label' => params[:search_label]}
    @labels = Label.where(user_id: nil).or(Label.where(user_id: current_user.id))
    @tasks = searched
    @tasks = @tasks.sorted
    @search_word = session[:search]['word']

    render :index
  end

  def sort
    @tasks = searched

    @search_word = session[:search]['word']  if session[:search].present?
    @labels = Label.where(user_id: nil).or(Label.where(user_id: current_user.id))
    @tasks =
      if params[:sort] == 'created_at'
        @tasks.sorted
      elsif params[:sort] == 'deadline'
        @tasks.deadline_sorted
      end

    session[:search] = nil

    render :index
  end

  private

  def task_params
    params.require(:task).permit(
      :name,
      :detail,
      :deadline,
      :status,
      :priority,
      label_ids: []
    )
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def forget_user
    if current_user.id != @task.user_id
      redirect_to root_path
    end
  end

  def searched
    if session[:search].present?
      # 全ての検索が空だったら
      if session[:search]['word'].blank? && session[:search]['status'].blank? && session[:search]['priority'].blank? && session[:search]['label'].blank?
        Task.current_user_sort(current_user.id).kaminari(params[:page])
      # ワードが入力されていて
      elsif session[:search]['word'].present?
        # ステータス、優先度、ラベルが指定されていたら
        if session[:search]['status'].present? && session[:search]['priority'].present? && session[:search]['label'].present?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['word']).status_sort(session[:search]['status']).priority_sort(session[:search]['priority']).label_sort(session[:search]['label']).kaminari(params[:page])
        # ステータス、優先度が指定されていたら
        elsif session[:search]['status'].present? && session[:search]['priority'].present?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['word']).status_sort(session[:search]['status']).priority_sort(session[:search]['priority']).kaminari(params[:page])
        # ステータス、ラベルが指定されていたら
        elsif session[:search]['status'].present? && session[:search]['label'].present? && session[:search]['priority'].blank?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['word']).status_sort(session[:search]['status']).label_sort(session[:search]['label']).kaminari(params[:page])
        # 優先度、ラベルが指定されていたら
        elsif session[:search]['priority'].present? && session[:search]['label'].present? && session[:search]['status'].blank?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['word']).priority_sort(session[:search]['priority']).label_sort(session[:search]['label']).kaminari(params[:page])
        # ステータスのみ指定されていたら
        elsif session[:search]['status'].present? && session[:search]['priority'].blank? && session[:search]['label'].blank?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['word']).status_sort(session[:search]['status']).kaminari(params[:page])
        # 優先度のみ指定されていたら
        elsif session[:search]['priority'].present? && session[:search]['status'].blank? && session[:search]['label'].blank?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['word']).priority_sort(session[:search]['priority']).kaminari(params[:page])
        # ラベルのみ指定されていたら
        elsif session[:search]['label'].present? && session[:search]['status'].blank? && session[:search]['priority'].blank?
          Task.current_user_sort(current_user.id).search_sort(session[:search]['word']).label_sort(session[:search]['label']).kaminari(params[:page])
        # ワードのみ
        else
          Task.current_user_sort(current_user.id).search_sort(session[:search]['word']).kaminari(params[:page])
        end
      # ワードが空、かつステータスが指定されていて
      elsif session[:search]['status'].present?
        # 優先度、ラベルが指定されていたら
        if session[:search]['priority'].present? && session[:search]['label'].present?
          Task.current_user_sort(current_user.id).status_sort(session[:search]['status']).priority_sort(session[:search]['priority']).label_sort(session[:search]['label']).kaminari(params[:page])
        # 優先度のみ指定されていたら
        elsif session[:search]['priority'].present? && session[:search]['label'].blank?
          Task.current_user_sort(current_user.id).status_sort(session[:search]['status']).priority_sort(session[:search]['priority']).kaminari(params[:page])
        # ラベルのみ指定されていたら
        elsif session[:search]['label'].present? && session[:search]['priority'].blank?
          Task.current_user_sort(current_user.id).status_sort(session[:search]['status']).label_sort(session[:search]['label']).kaminari(params[:page])
        # ステータスのみ
        else
          Task.current_user_sort(current_user.id).status_sort(session[:search]['status']).kaminari(params[:page])
        end
      # ワード、ステータスが空、かつ優先度が指定されていて
      elsif session[:search]['priority'].present?
        # ラベルが指定されていたら
        if session[:search]['label'].present?
          Task.current_user_sort(current_user.id).priority_sort(session[:search]['priority']).label_sort(session[:search]['label']).kaminari(params[:page])
        # 優先度のみ
        else
          Task.current_user_sort(current_user.id).priority_sort(session[:search]['priority']).kaminari(params[:page])
        end
      # ワード、ステータス、優先度が空、かつラベルが指定されていたら
      elsif session[:search]['label'].present?
        Task.current_user_sort(current_user.id).label_sort(session[:search]['label']).kaminari(params[:page])
      end
    else
      Task.current_user_sort(current_user.id).kaminari(params[:page])
    end
  end
end
