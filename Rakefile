require 'rubygems'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require "rake/rdoctask"

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |spec|
	spec.rspec_opts = ["--color", "--format", "nested"]
	spec.pattern = 'spec/**/*_spec.rb'
end

desc "Print specdocs"
RSpec::Core::RakeTask.new(:doc) do |spec|
	spec.rspec_opts = ["--format", "specdoc"]
	spec.pattern = 'spec/*_spec.rb'
end

desc "Generate the rdoc"
Rake::RDocTask.new do |rdoc|
	files = ["README.rdoc", "LICENSE", "lib/**/*.rb"]
	rdoc.rdoc_files.add(files)
	rdoc.main = "README.rdoc"
	rdoc.title = "ArtRest: Ruby Artifactory client"
end

desc "Run the rspec"
task :default => :spec
