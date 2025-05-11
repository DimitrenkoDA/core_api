class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :balance_transaction,
             class_name: "Transaction",
             foreign_key: :transaction_id,
             optional: true

  has_and_belongs_to_many :categories, class_name: "UserCategory"

  monetize :amount_cents
end
