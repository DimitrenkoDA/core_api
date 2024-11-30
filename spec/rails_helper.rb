require "spec_helper"

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../config/environment", __dir__)

if Rails.env.production?
  abort("The Rails environment is running in production mode!")
end

require "rspec/rails"

class ActionDispatch::TestResponse
  def json
    JSON.parse(body, symbolize_names: true)
  end
end

module StoreApi
  module RSpec
    module RequestHelpers
      def default_headers
        {
          "ACCEPT" => "application/json",
          "CONTENT_TYPE" => "application/json"
        }
      end
    end

    module GeneralHelpers
      def timestamp(timestamp)
        timestamp.utc.iso8601 unless timestamp.nil?
      end
    end
  end
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.use_transactional_fixtures = true

  config.include FactoryBot::Syntax::Methods

  config.include StoreApi::RSpec::GeneralHelpers
  config.include StoreApi::RSpec::RequestHelpers, type: :request
end
