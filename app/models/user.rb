class User < ApplicationRecord
  has_many :authentications, as: :owner

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_secure_password
end
