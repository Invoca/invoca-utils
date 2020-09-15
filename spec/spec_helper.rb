# frozen_string_literal: true

require 'rr'
require 'shoulda'
require 'pry'
require 'active_support/all'

require 'invoca/utils'
require 'rspec_junit_formatter'

RSpec.configure do |config|
  config.add_formatter(RspecJunitFormatter, 'spec/reports/rspec.xml')

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length = 2_000
end
