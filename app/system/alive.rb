module System
  class Alive
    def as_json(options = nil)
      {
        time: Time.zone.now.utc.iso8601,
        env: Rails.env.to_s,
        locale: I18n.locale,
        db: {
          version: ApplicationRecord.connection.query_value("SELECT version() as version")
        }
      }
    end
  end
end
