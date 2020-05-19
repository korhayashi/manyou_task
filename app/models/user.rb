class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  before_validation { email.downcase! }
  has_secure_password

  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: true
  validates :password, presence: true
end
