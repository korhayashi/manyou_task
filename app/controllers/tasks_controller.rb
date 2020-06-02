class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :not_logged_in

  def index
    # binding.irb
    @task = Task.new
    @tasks = current_user.tasks.sorted.kaminari(params[:page])
  end

  def new
    @task = Task.new
    @label = @task.labelings.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    binding.irb
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

  # def sort
  #   @tasks =
  #     if params[:sort] == 'created_at'
  #       Task.current_user_sort(current_user.id).order(created_at: :desc).kaminari(params[:page])
  #     elsif params[:sort] == 'deadline'
  #       Task.current_user_sort(current_user.id).order(deadline: :asc).kaminari(params[:page])
  #     end
  #
  #     render :index
  # end

  def search
    @search_word = params[:search_word]
    # binding.irb
    @tasks =
    # 全ての検索が空だったら
    if params[:search_word].blank? && params[:search_status].blank? && params[:search_priority].blank? && params[:search_label].blank?
      Task.current_user_sort(current_user.id).kaminari(params[:page])
    # ワードが入力されていて
    elsif params[:search_word].present?
      # ステータス、優先度、ラベルが指定されていたら
      if params[:search_status].present? && params[:search_priority].present? && params[:search_label].present?
        Task.current_user_sort(current_user.id).search_sort(params[:search_word]).status_sort(params[:search_status]).priority_sort(params[:search_priority]).label_sort(params[:search_label]).kaminari(params[:page])
      # ステータス、優先度が指定されていたら
      elsif params[:search_status].present? && params[:search_priority].present?
        Task.current_user_sort(current_user.id).search_sort(params[:search_word]).status_sort(params[:search_status]).priority_sort(params[:search_priority]).kaminari(params[:page])
      # ステータス、ラベルが指定されていたら
      elsif params[:search_status].present? && params[:search_label].present? && params[:search_priority].blank?
        Task.current_user_sort(current_user.id).search_sort(params[:search_word]).status_sort(params[:search_status]).label_sort(params[:search_label]).kaminari(params[:page])
      # 優先度、ラベルが指定されていたら
      elsif params[:search_priority].present? && params[:search_label].present? && params[:search_status].blank?
        Task.current_user_sort(current_user.id).search_sort(params[:search_word]).priority_sort(params[:search_priority]).label_sort(params[:search_label]).kaminari(params[:page])
      # ステータスのみ指定されていたら
      elsif params[:search_status].present? && params[:search_priority].blank? && params[:search_label].blank?
        Task.current_user_sort(current_user.id).search_sort(params[:search_word]).status_sort(params[:search_status]).kaminari(params[:page])
      # 優先度のみ指定されていたら
      elsif params[:search_priority].present? && params[:search_status].blank? && params[:search_label].blank?
        Task.current_user_sort(current_user.id).search_sort(params[:search_word]).priority_sort(params[:search_priority]).kaminari(params[:page])
      # ラベルのみ指定されていたら
      elsif params[:search_label].present? && parans[:search_status].blank? && params[:search_priority].blank?
        Task.current_user_sort(current_user.id).search_sort(params[:search_word]).label_sort(params[:search_label]).kaminari(params[:page])
      # ワードのみ
      else
        Task.current_user_sort(current_user.id).search_sort(params[:search_word]).kaminari(params[:page])
      end
    # ワードが空、かつステータスが指定されていて
    elsif params[:search_status].present?
      # 優先度、ラベルが指定されていたら
      if params[:search_priority].present? && params[:search_label].present?
        Task.current_user_sort(current_user.id).status_sort(params[:search_status]).priority_sort(params[:search_priority]).label_sort(params[:search_label]).kaminari(params[:page])
      # 優先度のみ指定されていたら
      elsif params[:search_priority].present? && params[:search_label].blank?
        Task.current_user_sort(current_user.id).status_sort(params[:search_status]).label_sort(params[:search_label]).kaminari(params[:page])
      # ラベルのみ指定されていたら
      elsif params[:search_label].present? && params[:search_priority].blank?
        Task.current_user_sort(current_user.id).status_sort(params[:search_status]).label_sort(params[:search_label]).kaminari(params[:page])
      # ステータスのみ
      else
        Task.current_user_sort(current_user.id).status_sort(params[:search_status]).kaminari(params[:page])
      end
    # ワード、ステータスが空、かつ優先度が指定されていて
    elsif params[:search_priority].present?
      # ラベルが指定されていたら
      if params[:search_label].present?
        Task.current_user_sort(current_user.id).priority_sort(params[:search_priority]).label_sort(params[:search_label]).kaminari(params[:page])
      # 優先度のみ
      else
        Task.current_user_sort(current_user.id).priority_sort(params[:search_priority]).kaminari(params[:page])
      end
    # ワード、ステータス、優先度が空、かつラベルが指定されていたら
    elsif params[:search_label].present?
      Task.current_user_sort(current_user.id).label_sort(params[:search_label]).kaminari(params[:page])
    end

    if params[:sort] == 'created_at'
      @tasks.sorted
    elsif params[:sort] == 'deadline'
      @tasks.deadline_sorted
    end

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

  # def params_search_word
  #   params.fetch(:search_word, {})
  # end
end
