# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "gutentag"
  s.version     = "3.0.0"
  s.authors     = ["Pat Allan"]
  s.email       = ["pat@freelancing-gods.com"]
  s.homepage    = "https://github.com/pat/gutentag"
  s.summary     = "Good Tags"
  s.description = "A good, simple, solid tagging extension for ActiveRecord"
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 3.0.0"

  s.add_runtime_dependency     "activerecord", ">= 3.2.0"

  s.add_development_dependency "appraisal",           "~> 2.5.0"
  s.add_development_dependency "bundler",             ">= 1.17"
  s.add_development_dependency "combustion",          "~> 1.1"
  s.add_development_dependency "database_cleaner",    "~> 2.1"
  s.add_development_dependency "rails"
  s.add_development_dependency "rspec-rails",         ">= 5.1.2"
  s.add_development_dependency "rubocop",             "~> 1.81.7"
  s.add_development_dependency "rubocop-performance", "~> 1.26"
end
