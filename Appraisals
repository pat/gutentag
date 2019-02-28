# frozen_string_literal: true

appraise "rails_4_0" do
  gem "rails",   "~> 4.0.13"
  gem "mysql2",  "~> 0.3.10", :platform => :ruby
end if RUBY_VERSION.to_f < 2.4

appraise "rails_4_1" do
  gem "rails",   "~> 4.1.16"
  gem "mysql2",  "~> 0.3.13", :platform => :ruby
end if RUBY_VERSION.to_f < 2.4

appraise "rails_4_2" do
  gem "rails",   "~> 4.2.8"
  gem "mysql2",  "~> 0.4.0", :platform => :ruby

  gem "activerecord-jdbcmysql-adapter",      "~> 1.3.23", :platform => :jruby
  gem "activerecord-jdbcpostgresql-adapter", "~> 1.3.23", :platform => :jruby
  gem "activerecord-jdbcsqlite3-adapter",    "~> 1.3.23", :platform => :jruby
end

appraise "rails_5_0" do
  gem "rails",  "~> 5.0.3"
  gem "mysql2", "~> 0.4.0", :platform => :ruby
end if RUBY_VERSION.to_f >= 2.2

appraise "rails_5_1" do
  gem "rails",  "~> 5.1.1"
  gem "mysql2", "~> 0.4.0", :platform => :ruby
end if RUBY_VERSION.to_f >= 2.2

appraise "rails_5_2" do
  gem "rails",  "~> 5.2.0"
  gem "pg",     "~> 1.0",   :platform => :ruby
  gem "mysql2", "~> 0.5.0", :platform => :ruby
end if RUBY_VERSION.to_f >= 2.2

appraise "rails_6_0" do
  gem "rails",  "~> 6.0.0.beta1"
  gem "pg",     "~> 1.0",   :platform => :ruby
  gem "mysql2", "~> 0.5.0", :platform => :ruby
end if RUBY_VERSION.to_f >= 2.5 && RUBY_PLATFORM != "java"
