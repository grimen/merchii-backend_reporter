# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'merchii/background_reporter/version'

Gem::Specification.new do |s|
  s.name        = "merchii-background_reporter"
  s.version     = Merchii::BackgroundReporter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jonas Grimfelt", "Jaakko Suutarla"]
  s.email       = ["operations@merchii.com"]
  s.homepage    = "https://github.com/merchii/merchii-background_reporter"
  s.summary     = %q{}
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'fog'
  s.add_runtime_dependency 'multi_json'
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'activesupport'
  # s.add_runtime_dependency 'connection_pool'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest', '~> 2.9.1'
  s.add_development_dependency 'minitest-matchers'
  s.add_development_dependency 'purdytest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'guard-minitest'
  s.add_development_dependency 'awesome_print'
end
