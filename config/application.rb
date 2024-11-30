require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CoreAPI
  class Application < Rails::Application
    config.load_defaults 7.1
    config.active_record.yaml_column_permitted_classes = [Symbol, Hash, Array, ActiveSupport::HashWithIndifferentAccess]
    config.i18n.default_locale = :en

    config.paths["app"].glob = nil

    config.api_only = true
  end
end
