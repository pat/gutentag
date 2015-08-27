require 'bundler'

# Get Bundler set up
Bundler.setup :default, :development
# Require Rails first
require 'rails'
# Then require everything else
Bundler.require :default, :development

Combustion.initialize! :active_record

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
