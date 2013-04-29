require 'bundler'

Bundler.require :default, :test

Combustion.initialize!

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
