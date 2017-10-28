appraise "rails_3_2" do
  gem "rails",    "~> 3.2.22.5"
  gem "mysql2",   "~> 0.3.10", :platform => :ruby
end if RUBY_VERSION.to_f <= 2.2

appraise "rails_4_0" do
  gem "rails",    "~> 4.0.13"
  gem "mysql2",   "~> 0.3.10", :platform => :ruby
end if RUBY_VERSION.to_f < 2.4

appraise "rails_4_1" do
  gem "rails",    "~> 4.1.16"
  gem "mysql2",   "~> 0.3.13", :platform => :ruby
end if RUBY_VERSION.to_f < 2.4

appraise "rails_4_2" do
  gem "rails",    "~> 4.2.8"
end if RUBY_VERSION.to_f < 2.4

appraise "rails_5_0" do
  gem "rails", "~> 5.0.3"
end if RUBY_VERSION.to_f >= 2.2 && RUBY_PLATFORM != "java"

appraise "rails_5_1" do
  gem "rails", "~> 5.1.1"
end if RUBY_VERSION.to_f >= 2.2 && RUBY_PLATFORM != "java"
