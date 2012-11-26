require 'addressable/uri'
require 'rest-client'
require 'json'
require 'mime/types'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/kernel/singleton_class'

require 'artrest/version'
require 'artrest/resource'
require 'artrest/resources'
require 'artrest/system'
require 'artrest/system_general_configuration'
require 'artrest/repositories'
require 'artrest/repository'
require 'artrest/dir_entry'
require 'artrest/builds'
require 'artrest/build'
require 'artrest/buildnumber'

module ArtRest

    class << self
        attr_accessor :options
    end

    # Cache supplied +base_url+, +username+ and +password+ prior to using this
    # API.
    #
    # * *Args*    :
    #   - +base_url+ -> Our Artifactory server's URL, typically
    #     http://localhost:8081/artifactory
    #   - +username+ -> Username used when connecting to Artifactory
    #   - +password+ -> Password used when connecting to Artifactory
    #   - +options+ -> Additional connections parameters, currently unused
    # * *Raises* :
    #   - +ArgumentError+ -> If one of the parameters is +nil+
    #
    def self.connect(base_url, user, password, options = {})
        raise ArgumentError.new "Must pass base_url" unless base_url
        raise ArgumentError.new "Must pass user" unless user
        raise ArgumentError.new "Must pass password" unless password
        self.options = {
            :base_url => base_url,
            :user     => user,
            :password => password
        }
        self.options.merge!(options)
    end

    # Return *the* ArtRest::System resource.
    #
    # * *Returns* :
    #   - *The* ArtRest::System resource
    # * *Raises* :
    #   - +RuntimeException+ -> If you didn't call ::connect prior to calling
    #     this method
    #
    def self.system
        self.check_connected
        System.get(self.options[:base_url], self.options)
    end

    # Return *the* ArtRest::Builds resource.
    #
    # * *Returns* :
    #   - *The* ArtRest::Builds resource
    # * *Raises* :
    #   - +RuntimeException+ -> If you didn't call ::connect prior to calling
    #     this method
    #
    def self.builds
        self.check_connected
        Builds.get(self.options[:base_url], self.options)
    end

    private

    def self.check_connected
        raise RuntimeError, "You need to call ArtRest::connect prior to using this API" unless self.options
    end
end
