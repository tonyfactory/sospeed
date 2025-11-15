# -*- coding: utf-8 -*-

# Set environment to test to bypass user input
ENV['RUBY_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!