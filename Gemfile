source 'https://rubygems.org'

gemspec

gem 'test-unit', :platform => :ruby_22
gem 'rack',       '~> 1.0'   if RUBY_VERSION.to_f <= 2.1
gem 'nokogiri',   '~> 1.6.0' if RUBY_VERSION.to_f <= 2.0

gem 'combustion', '~> 0.6',
  :git    => 'https://github.com/pat/combustion.git',
  :branch => 'master',
  :ref    => 'ef434634d7'
