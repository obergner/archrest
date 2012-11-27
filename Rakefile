require 'rubygems'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
if RUBY_VERSION <= '1.9.0'
    require "rake/rdoctask"
else
    require 'rdoc/task'
end

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
    files = ["README.md", "LICENSE.txt", "lib/**/*.rb"]
    rdoc.rdoc_files.add(files)
    rdoc.main = "README.md"
    rdoc.title = "ArtRest: Ruby Artifactory client"
end

desc "Run the rspec"
task :default => :spec
