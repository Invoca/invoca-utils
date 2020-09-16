#!/usr/bin/env rake
# frozen_string_literal: true

require "bundler/gem_tasks"
require 'rake'

desc "run rspec unit tests"
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:rspec) do |rspec_task|
    rspec_task.pattern = "spec/**{,/*/**}/*_spec.rb"
  end
end

task default: :rspec
