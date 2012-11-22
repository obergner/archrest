require 'bundler/setup'
require 'rubygems'
require 'rspec'
require 'webmock/rspec'

require File.join(File.dirname(__FILE__), '..','lib','artrest')

unless defined?(ARTIFACTORY_URL)
    FIXTURE_PATH       = File.join(File.dirname(__FILE__), '/fixtures')

    ARTIFACTORY_URL    = ENV['ARTIFACTORY_URL'] || 'http://dev.vhost.net:8081/artifactory'
    ARTIFACTORY_USER   = ENV['ARTIFACTORY_USER'] || 'admin'
    ARTIFACTORY_PWD    = ENV['ARTIFACTORY_PWD'] || 'general42'


    OPTIONS            = {  :base_url => ARTIFACTORY_URL,     :artifactory_url => ARTIFACTORY_URL, 
                            :user => ARTIFACTORY_USER,   :artifactory_user => ARTIFACTORY_USER, 
                            :password => ARTIFACTORY_PWD, :artifactory_password => ARTIFACTORY_PWD }
end

# Convenience function to easily load stub requests
def load_stub_request(relative_path)
    File.new(File.expand_path(relative_path, FIXTURE_PATH))
end

# Convenience function to easily register stub requests
def register_stub_request(request_file_path, relative_uri, method = :get, auth = true)
    req_file = load_stub_request(request_file_path)
    request_url = "#{ARTIFACTORY_URL}/#{relative_uri}"
    request_url.gsub!('http://', "http://#{ARTIFACTORY_USER}:#{ARTIFACTORY_PWD}@")
    stub_request(method, request_url).to_return req_file 
end
