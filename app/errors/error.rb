module Errors
  class Error
    attr_reader :messages
    attr_reader :attributes

    def self.alert(*messages)
      Errors::Error.new(messages: messages)
    end

    def initialize(messages: [], attributes: {})
      @messages = messages
      @attributes = {}

      attributes.each do |key, val|
        if val.is_a?(Array) # || val.is_a?(ActiveModel::DeprecationHandlingMessageArray)
          @attributes[key] = Errors::Error.new(messages: val)
        elsif val.is_a?(Errors::Error)
          @attributes[key] = val
        else
          @attributes[key] = Errors::Error.new(attributes: val)
        end
      end
    end

    def present?
      @messages.present? || @attributes.present?
    end

    def blank?
      !present?
    end

    def as_json(options = nil)
      attributes = {}

      @attributes.each do |key, err|
        attributes[key] = err.as_json
      end

      json = {}
      json[:messages] = messages if messages.any?
      json[:attributes] = attributes if attributes.any?
      json
    end

    def <<(error)
      if error.is_a?(String)
        error = Errors::Error.alert(error)
      end

      merge!(error)
    end

    def merge!(error)
      @messages = @messages + error.messages

      error.attributes.each do |key, err|
        @attributes[key] ||= Error.new
        @attributes[key].merge!(err)
      end
    end
  end
end
