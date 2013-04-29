# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'gutentag'
  s.version     = '0.1.0'
  s.authors     = ['Pat Allan']
  s.email       = ['pat@freelancing-gods.com']
  s.homepage    = 'https://github.com/pat/gutentag'
  s.summary     = 'Good Tags'
  s.description = 'A good, simple, solid tagging extension for ActiveRecord'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency     'activerecord', '>= 3.2.0'
  s.add_development_dependency 'combustion',   '~> 0.4.0'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
end
