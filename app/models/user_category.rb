class UserCategory < ApplicationRecord
  belongs_to :user

  validates :kind, presence: true
  validates :name, presence: true, uniqueness: true
  validates :colour_code, presence: true, format: { with: /\A#[0-9a-f]{6}\z/i }

  enum :kind, {
    payment: "payment",
    income: "income"
  }

  def owned_by?(someone)
    user == someone
  end
end
