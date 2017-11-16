# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'busser/serverspec/version'

Gem::Specification.new do |spec|
  spec.name          = 'busser-serverspec'
  spec.version       = Busser::Serverspec::VERSION
  spec.authors       = ['HIGUCHI Daisuke']
  spec.email         = ['d-higuchi@creationline.com']
  spec.description   = %q{A Busser runner plugin for Serverspec}
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/test-kitchen/busser-serverspec'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'busser'
  if RUBY_VERSION < '2.0'
    spec.add_dependency 'rake', '< 12.3.0'
  else
    spec.add_dependency 'rake'
  end
  spec.add_dependency 'rspec-core'

  spec.add_development_dependency 'serverspec'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'aruba', '0.6.1'
  spec.add_development_dependency 'cucumber', '1.3.18'

  spec.add_development_dependency 'cane'
  spec.add_development_dependency 'log_switch', '~> 0.3.0'
  spec.add_development_dependency 'tailor'
  spec.add_development_dependency 'countloc'

  spec.add_development_dependency 'coveralls'

  if RUBY_VERSION < '2.0'
    spec.add_development_dependency 'net-ssh', '< 2.10'
    spec.add_development_dependency 'tins', '< 1.7'
    spec.add_development_dependency 'nokogiri', '< 1.7.0'
    spec.add_development_dependency 'mime-types', '< 3.0'
    spec.add_development_dependency 'term-ansicolor', '< 1.4.0'
    spec.add_development_dependency 'rest-client', '< 2.0'
  end
end
