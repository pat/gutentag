# frozen_string_literal: true

require "bundler/setup"

Bundler.require :default, :development

Dir["#{__dir__}/support/**/*.rb"].each { |file| require file }

Combustion.initialize! :active_record
ActiveSupport.run_load_hooks :gutentag unless defined?(Gutentag::Engine)

require "rspec/rails"

RSpec.configure do |config|
  if config.respond_to?(:use_transactional_tests)
    config.use_transactional_tests = false
  else
    config.use_transactional_fixtures = false
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
