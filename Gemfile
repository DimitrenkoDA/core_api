source "https://rubygems.org"

ruby "3.4.1"
gem "rails", "~> 7.1.4"
gem "puma", ">= 5.0"
gem "kredis"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "dry-container"
gem "groupdate"
gem "httparty"
gem "pg"
gem "sidekiq", "~> 7", "< 8"
gem "sidekiq-cron"
gem "strong_migrations"
gem "jwt"
gem "faker"
gem "dry-validation"
gem "money-rails"
gem "rotp"
gem "ice_cube"
gem "csv" # not a part of standard library as of Ruby 3.4.0
gem "logger" # not a part of standard library as of Ruby 3.5.0
gem "ostruct" # not a part of standard library as of Ruby 3.5.0

group :development, :test do
  gem "rubocop", require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false # если используешь RSpec
  gem "bundler-audit", require: false
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails", require: "dotenv/rails-now"
  gem "factory_bot_rails"
  gem "rspec-rails"
end

group :test do
  gem "webmock"
  gem "timecop"
end
