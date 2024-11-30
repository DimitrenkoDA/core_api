class Authentication < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :prev_authentication, class_name: "Authentication", optional: true

  enum :step, {
    password: "password",
    complete: "complete"
  }

  def expired?
    expires_at.present? && expires_at < Time.zone.now
  end
end
