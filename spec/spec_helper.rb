require 'bundler/setup'

require 'single_cov'
SingleCov.setup :rspec

Bundler.require :default, :development

Combustion.initialize! :active_record

require 'rspec/rails'

RSpec.configure do |config|
  if config.respond_to?(:use_transactional_tests)
    config.use_transactional_tests = true
  else
    config.use_transactional_fixtures = true
  end
end
