module Types
  include Dry.Types()
end

module Dry
  module Types
    module Coercions
      module JSON
        def self.to_float(input, &block)
          Float(input)
        rescue ArgumentError, TypeError => e
          CoercionError.handle(e, &block)
        end

        def self.to_string(input, &block)
          input = input.is_a?(String) ? input.strip.chomp : input

          String(input)
        rescue ArgumentError, TypeError => e
          CoercionError.handle(e, &block)
        end

        def self.to_uuid(input, &block)
          if input.is_a?(String) && input =~ /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/
            input
          else
            CoercionError.handle("Invalid UUID format", &block)
          end
        end
      end
    end

    register("json.float") do
      self["nominal.float"].constructor(Coercions::JSON.method(:to_float))
    end

    register("json.string") do
      self["nominal.string"].constructor(Coercions::JSON.method(:to_string))
    end

    register("uuid") do
      self["nominal.string"].constructor(Coercions::JSON.method(:to_uuid))
    end
  end
end
