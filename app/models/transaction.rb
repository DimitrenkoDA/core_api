class Transaction < ApplicationRecord
  belongs_to :user

  validates :polarity, presence: true

  enum :polarity, {
    credit: "credit",
    debit: "debit",
  }

  monetize :amount_cents

  def owned_by?(someone)
    user == someone
  end
end
