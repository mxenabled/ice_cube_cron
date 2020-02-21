# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'ice_cube_cron/version'

Gem::Specification.new do |s|
  s.name          = 'ice_cube_cron'
  s.version       = IceCubeCron::VERSION
  s.authors       = ['Matt Nichols']
  s.email         = ['matt@nichols.name']
  s.homepage      = 'https://github.com/mattnichols/ice_cube_cron'
  s.summary       = 'Adds ability to create ice_cube schedules from cron expressions.'
  s.description   = 'Adds methods to ice_cube that creation of schedules using standard cron expressions.'
  s.license       = 'MIT'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  ##
  # Dependencies
  #
  s.add_dependency 'activesupport'
  s.add_dependency 'ice_cube', '~> 0.16.0'

  ##
  # Development Dependencies
  #
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'rake', '~> 10'
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'rubocop', '~> 0'
end
