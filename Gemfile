# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "mysql2",  "~> 0.5", :platform => :ruby
gem "pg",      "~> 1.0", :platform => :ruby

if RUBY_VERSION.to_f < 3.0
  gem "sqlite3", "~> 1.3.13"
else
  gem "sqlite3", ">= 1.4"
end

gem "activerecord-jdbcmysql-adapter",      ">= 1.3.23", :platform => :jruby
gem "activerecord-jdbcpostgresql-adapter", ">= 1.3.23", :platform => :jruby
gem "activerecord-jdbcsqlite3-adapter",    ">= 1.3.23", :platform => :jruby

gem "activerecord", [">= 5.2"] if RUBY_PLATFORM == "java"

# Required for testing Rails 6.1 on MRI 3.1+
gem "net-smtp" if RUBY_VERSION.to_f > 3.0
# mutex_m is no longer a default gem in MRI 3.4, warnings in 3.3
gem "mutex_m" if RUBY_VERSION.to_f > 3.2
