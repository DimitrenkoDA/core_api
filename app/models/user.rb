class User < ApplicationRecord
  has_many :authentications, as: :owner
  has_many :categories, class_name: "UserCategory"
  has_many :incomes
  has_many :payments
  has_many :transactions

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_secure_password
end
