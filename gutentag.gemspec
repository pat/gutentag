# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'gutentag'
  s.version     = '0.7.1'
  s.authors     = ['Pat Allan']
  s.email       = ['pat@freelancing-gods.com']
  s.homepage    = 'https://github.com/pat/gutentag'
  s.summary     = 'Good Tags'
  s.description = 'A good, simple, solid tagging extension for ActiveRecord'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency     'activerecord', '>= 3.2.0'

  s.add_development_dependency 'appraisal',    '~> 1.0.2'
  s.add_development_dependency 'bundler',      '>= 1.7.12'
  s.add_development_dependency 'combustion',   '0.5.5'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sqlite3',      '~> 1.3.7'
end
