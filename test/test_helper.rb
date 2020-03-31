# frozen_string_literal: true

require "minitest/autorun"
require 'rr'
require 'shoulda'
require 'pry'
require 'active_support/all'

require 'invoca/utils'
require "minitest/reporters"
Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new,
  Minitest::Reporters::JUnitReporter.new
]
