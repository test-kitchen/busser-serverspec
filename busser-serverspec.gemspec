lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "busser/serverspec/version"

Gem::Specification.new do |spec|
  spec.name          = "busser-serverspec"
  spec.version       = Busser::Serverspec::VERSION
  spec.authors       = ["HIGUCHI Daisuke"]
  spec.email         = ["d-higuchi@creationline.com"]
  spec.description   = "A Busser runner plugin for Serverspec"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/test-kitchen/busser-serverspec"
  spec.license       = "Apache-2.0"

  spec.required_ruby_version = ">= 3.2"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "documentation_uri" => "#{spec.homepage}/blob/main/README.md",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
  }

  # The runner shells out to rake and loads rspec-core inside the system under
  # test, so both are runtime dependencies rather than development ones.
  spec.add_dependency "busser", ">= 0.9.0"
  spec.add_dependency "rake"
  spec.add_dependency "rspec-core"
end
