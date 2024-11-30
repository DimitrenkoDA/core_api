module Authentications
  class Builder
    def initialize(owner)
      @owner = owner
    end

    def password(prev_authentication = nil)
      @owner.authentications.create!(
        prev_authentication: prev_authentication,
        step: :password,
        expires_at: Time.zone.now + 1.year
      )
    end

    def complete(prev_authentication = nil)
      @owner.authentications.create!(
        prev_authentication: prev_authentication,
        step: :complete,
        expires_at: Time.zone.now + 1.year
      )
    end
  end
end
