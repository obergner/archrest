require 'bundler/setup'
require 'rubygems'
require 'rspec'

require File.join(File.dirname(__FILE__), '..','lib','artrest')

unless defined?(ARTIFACTORY_URL)
	ARTIFACTORY_URL = ENV['ARTIFACTORY_URL'] || 'http://dev.vhost.net:8081/artifactory'
	ARTIFACTORY_USER = ENV['ARTIFACTORY_USER'] || 'admin'
	ARTIFACTORY_PWD = ENV['ARTIFACTORY_PWD'] || 'general42'
end
