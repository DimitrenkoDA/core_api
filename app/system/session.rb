module System
  class Session
    class Kind
      AVAILABLE_KINDS = ["user"].freeze

      def initialize(value)
        @value = value.to_s.underscore
      end

      def valid?
        @value.present? && AVAILABLE_KINDS.include?(@value)
      end

      def owner_class
        class_name = @value.classify
        class_name.classify.constantize
      end

      def to_s
        @value.to_s
      end

      def as_json(options = {})
        @value.to_s
      end

      AVAILABLE_KINDS.each do |kind|
        define_method "#{kind}?" do
          kind == @value
        end
      end
    end

    def self.build(owner)
      System::Session.new(token(owner))
    end

    def self.token(owner)
      payload = {
        uuid: SecureRandom.uuid,
        kind: Kind.new(owner.class.name.underscore),
        owner: {
          id: owner.id
        }
      }

      JWT.encode(payload, Rails.application.credentials.secret_key_base, "HS256")
    end

    attr_reader :token

    def initialize(token)
      @token = token
    end

    def valid?
      return false if !kind.valid?
      return false if owner.blank?
      return false unless owner.is_a?(User)

      true
    end

    def payload
      return @payload if defined?(@payload)

      begin
        @payload = JWT.decode(@token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256")[0]
        @payload.deep_symbolize_keys! if @payload.present?
      rescue StandardError => error
        {}
      end
    end

    def owner
      @owner ||= kind.owner_class.find_by(id: payload[:owner][:id])
    end

    def owned_by?(someone)
      owner == someone
    end

    def uuid
      @uuid ||= payload[:uuid].to_s
    end

    def kind
      @kind ||= Kind.new(payload[:kind])
    end

    def to_s
      "#{kind}:#{owner.id}"
    end
  end
end
