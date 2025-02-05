class User < ApplicationRecord
  has_many :authentications, as: :owner
  has_many :transactions
  has_many :categories, class_name: "UserCategory"

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_secure_password
end
