class Task < ApplicationRecord
  belongs_to :user
  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings, source: :label

  validates :name, presence: true
  validates :detail, presence: true
  validates :deadline, presence: true

  enum status: {
    未着手: 0,
    着手中: 1,
    完了: 2
  }

  enum priority: {
    低: 0,
    中: 1,
    高: 2
  }

  # created_atを降順で取得する
  scope :sorted, -> { order(created_at: :desc) }
  # deadlineを昇順で取得する
  scope :deadline_sorted, -> { order(deadline: :asc) }
  # 着手の度合いでソート
  scope :status_sort, -> (search_status){ where(status: search_status) }
  # 検索ワードであいまい検索をしてソート
  scope :search_sort, -> (search_word){ where('name LIKE ?', "%#{search_word}%") }
  # 重要度でソート
  scope :priority_sort, -> (search_priority){ where(priority: search_priority) }
  # ラベルでソート
  scope :label_sort, -> (search_label){
    tasks = Labeling.where(label_id: search_label)
    ids = tasks.map{ |task| task.task_id }
    # binding.irb
    where(id: ids)
  }
  # kaminari関連
  scope :kaminari, -> (kaminari_page){ page(kaminari_page).per(5) }
  # ログイン中のユーザーで取得
  scope :current_user_sort, -> (current_user_id){ where(user_id: current_user_id) }
end
