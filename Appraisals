# frozen_string_literal: true

if RUBY_PLATFORM != "java"
  appraise "rails_6_1" do
    gem "rails",       "~> 6.1.0"
    gem "rspec-rails", "~> 6.1"
    gem "pg",          "~> 1.0",   :platform => :ruby
    gem "mysql2",      "~> 0.5.0", :platform => :ruby
    gem "sqlite3",     "~> 1.4",   :platform => :ruby
  end

  appraise "rails_7_0" do
    gem "rails",       "~> 7.0.8.6"
    gem "rspec-rails", "~> 7.1"
    gem "pg",          "~> 1.0",   :platform => :ruby
    gem "mysql2",      "~> 0.5.0", :platform => :ruby
    gem "sqlite3",     "~> 1.4",   :platform => :ruby
  end

  appraise "rails_7_1" do
    gem "rails",       "~> 7.1.5"
    gem "rspec-rails", "~> 7.1"
    gem "pg",          "~> 1.0",   :platform => :ruby
    gem "mysql2",      "~> 0.5.0", :platform => :ruby
    gem "sqlite3",     "~> 2.0",   :platform => :ruby
  end if RUBY_VERSION.to_f >= 3.1

  appraise "rails_7_2" do
    gem "rails",       "~> 7.2.2"
    gem "rspec-rails", "~> 7.1"
    gem "pg",          "~> 1.0",   :platform => :ruby
    gem "mysql2",      "~> 0.5.0", :platform => :ruby
    gem "sqlite3",     "~> 2.0",   :platform => :ruby
  end if RUBY_VERSION.to_f >= 3.1

  appraise "rails_8_0" do
    gem "rails",       "~> 8.0.0"
    gem "rspec-rails", "~> 8.0"
    gem "pg",          "~> 1.0",   :platform => :ruby
    gem "mysql2",      "~> 0.5.0", :platform => :ruby
    gem "sqlite3",     "~> 2.3",   :platform => :ruby
  end if RUBY_VERSION.to_f >= 3.2

  appraise "rails_8_1" do
    gem "rails",       "~> 8.1.0"
    gem "rspec-rails", "~> 8.0"
    gem "pg",          "~> 1.0",   :platform => :ruby
    gem "mysql2",      "~> 0.5.0", :platform => :ruby
    gem "sqlite3",     "~> 2.3",   :platform => :ruby
  end if RUBY_VERSION.to_f >= 3.2
end
