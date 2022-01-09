# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "test-unit", :platform => :ruby_22

gem "mysql2",  "~> 0.3",    :platform => :ruby
gem "pg",      "~> 0.18",   :platform => :ruby

if RUBY_VERSION.to_f < 3.0
  gem "sqlite3", "~> 1.3.13"
else
  gem "sqlite3", "~> 1.4"
end

gem "activerecord-jdbcmysql-adapter",      ">= 1.3.23", :platform => :jruby
gem "activerecord-jdbcpostgresql-adapter", ">= 1.3.23", :platform => :jruby
gem "activerecord-jdbcsqlite3-adapter",    ">= 1.3.23", :platform => :jruby

gem "activerecord", [">= 3.2.22"] if RUBY_PLATFORM == "java"

# Required for testing Rails 6.1 on MRI 3.1+
gem "net-smtp" if RUBY_VERSION.to_f > 3.0
