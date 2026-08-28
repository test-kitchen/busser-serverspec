lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "busser/serverspec/version"

Gem::Specification.new do |spec|
  spec.name          = "busser-serverspec"
  spec.version       = Busser::Serverspec::VERSION
  spec.authors       = ["HIGUCHI Daisuke"]
  spec.email         = ["d-higuchi@creationline.com"]
  spec.description   = %q{A Busser runner plugin for Serverspec}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/test-kitchen/busser-serverspec"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "busser", ">= 0.9.0"
  spec.add_dependency "rake"
  spec.add_dependency "rspec-core"

  spec.add_development_dependency "serverspec"
  spec.add_development_dependency "aruba", ">= 2.0"
  spec.add_development_dependency "cucumber", ">= 11.1"
end
