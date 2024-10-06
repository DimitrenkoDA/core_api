require "spec_helper"

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../config/environment", __dir__)

if Rails.env.production?
  abort("The Rails environment is running in production mode!")
end

require "rspec/rails"
require "sidekiq/testing"
require "sidekiq_unique_jobs/testing"
require "chewy/rspec"

Sidekiq::Testing.fake!

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
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include StoreApi::RSpec::RequestHelpers, type: :request

  config.after { Kredis.clear_all } # cleans up all the mess we created after testing

  config.before :each do
    I18n.locale = :en
  end

  RSpec::Sidekiq.configure do |config|
    config.warn_when_jobs_not_processed_by_sidekiq = false
  end
end
