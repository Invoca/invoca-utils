lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invoca/utils/version'

Gem::Specification.new do |spec|
  spec.name          = "invoca-utils"
  spec.version       = Invoca::Utils::VERSION
  spec.authors       = ["Invoca development"]
  spec.email         = ["development@invoca.com"]
  spec.summary       = "A public collection of helpers used in multiple projects"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.metadata = {
    'allowed_push_host' => 'https://rubygems.org'
  }

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
