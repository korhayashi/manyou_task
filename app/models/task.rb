class Task < ApplicationRecord
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

  # created_atカラムを降順で取得する
  scope :sorted, -> { order(created_at: :desc) }
  # 着手の度合いでソート
  scope :status_sort, -> (search_status){ where(status: search_status) }
  # 検索ワードであいまい検索をしてソート
  scope :search_sort, -> (search_word){ where('name LIKE ?', "%#{search_word}%") }
  # 重要度でソート
  scope :priority_sort, -> (search_priority){ where(priority: search_priority) }
end
