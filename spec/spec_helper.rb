# -*- encoding: utf-8 -*-
require 'minitest/autorun'
require 'minitest/unit'
require 'minitest/spec'
require 'minitest/pride'
require 'minitest/matchers'
require 'mocha'
require 'ap'
require 'pp'

ENV['AWS_ACCESS_KEY'] ||= 'mocked'
ENV['AWS_ACCESS_SECRET'] ||= 'mocked'

require 'merchii/background_reporter'