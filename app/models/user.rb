class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  before_destroy :destroy_action
  before_update :update_action

  before_validation { email.downcase! }
  has_secure_password

  validates :name,  presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: true
  validates :password, presence: true, on: :create
  validates :password, length: { maximum: 30 }, allow_blank: true, on: :update

  private

  def destroy_action
    if User.where(admin: true).count == 1 && self.admin
      throw(:abort)
    end
  end

  def update_action
    user = User.where(id: self.id).where(admin: true)
    # binding.irb
    if User.where(admin: true).count == 1 && user.present? && self.admin == false
      errors.add(:admin, 'から外せません。最低一人の管理者が必要です')
      throw(:abort)
    end
  end
end
