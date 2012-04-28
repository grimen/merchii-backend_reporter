#!/usr/bin/env rake
require 'bundler'
Bundler::GemHelper.install_tasks
require "rake/testtask"

task :default => :test

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.ruby_opts += ['-rubygems']
  t.libs << 'spec'
  t.pattern = 'spec/**/*_spec.rb'
end
