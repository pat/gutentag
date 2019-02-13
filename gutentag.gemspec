# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = "gutentag"
  s.version     = "2.4.0"
  s.authors     = ["Pat Allan"]
  s.email       = ["pat@freelancing-gods.com"]
  s.homepage    = "https://github.com/pat/gutentag"
  s.summary     = "Good Tags"
  s.description = "A good, simple, solid tagging extension for ActiveRecord"
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency     "activerecord", ">= 3.2.0"

  s.add_development_dependency "appraisal",        "~> 2.1.0"
  s.add_development_dependency "bundler",          "~> 1.17"
  s.add_development_dependency "combustion",       "~> 1.1"
  s.add_development_dependency "database_cleaner", "~> 1.6"
  s.add_development_dependency "rails"
  s.add_development_dependency "rspec-rails",      "~> 3.1"
  s.add_development_dependency "rubocop",          "~> 0.64.0"
end
