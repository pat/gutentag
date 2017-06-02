require 'bundler/setup'

require 'single_cov'
SingleCov.setup :rspec

Bundler.require :default, :development

ENV["DATABASE_URL"] ||= case ENV["DATABASE"]
when "mysql", "mysql2"
  "mysql2://root@localhost/gutentag"
when "postgres", "postgresql", "pg"
  "postgres://localhost/gutentag"
else
  "sqlite:///#{File.expand_path("spec/internal/db/gutentag_test.sqlite")}"
end

Combustion.initialize! :active_record

require 'rspec/rails'

RSpec.configure do |config|
  if config.respond_to?(:use_transactional_tests)
    config.use_transactional_tests = true
  else
    config.use_transactional_fixtures = true
  end
end
