class Contact < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :user

  validates :user_id, uniqueness: { scope: :owner_id }
end
