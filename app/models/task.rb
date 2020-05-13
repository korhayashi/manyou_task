class Task < ApplicationRecord
  validates :name, presence: true
  validates :detail, presence: true
  validates :deadline, presence: true

  enum status: {
    未着手: 0,
    着手中: 1,
    完了: 2
  }
end
