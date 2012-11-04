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
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency     'rest-client'
  gem.add_runtime_dependency     'json'
  gem.add_runtime_dependency     'active_support'
  
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
end
