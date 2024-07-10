# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'invoca/utils/version'

Gem::Specification.new do |spec|
  spec.name          = "invoca-utils"
  spec.version       = Invoca::Utils::VERSION
  spec.licenses      = ["MIT"]

  spec.authors       = ["Invoca development"]
  spec.email         = ["development@invoca.com"]

  spec.summary       = "A public collection of helpers used in multiple projects"
  spec.description   = "A public collection of helpers used in multiple projects"
  spec.homepage      = "https://github.com/Invoca/invoca-utils"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # this should match the minimum github pipeline targets
  # which is currently set to 3.1
  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "activesupport", ">= 6.0"

  # Specify this gem's development and test dependencies in Gemfile
end
