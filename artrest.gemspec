# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'artrest/version'

Gem::Specification.new do |gem|
  gem.name          = "artrest"
  gem.version       = ArtRest::VERSION
  gem.authors       = ["Olaf Bergner"]
  gem.email         = ["olaf.bergner@gmx.de"]
  gem.description   = %q{ArtRest: A Ruby REST client for Artifactory}
  gem.summary       = %q{ArtRest is a commandline client for the Artifactory REST API}
  gem.homepage      = "http://github.com/obergner/artrest"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency     'rest-client', '1.6.7'
  gem.add_runtime_dependency     'json', '1.7.5'
  gem.add_runtime_dependency     'activesupport', '3.0.0'
  gem.add_runtime_dependency     'gli', '2.4.1'
  gem.add_runtime_dependency     'mime-types', '1.19'
  
  gem.add_development_dependency 'rake', '0.9.2.2'
  gem.add_development_dependency 'rspec', '2.11.0'
  gem.add_development_dependency 'webmock', '1.9.0'
end
