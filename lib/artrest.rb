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
require 'artrest/repositories'
require 'artrest/repository'
require 'artrest/dir_entry'
require 'artrest/builds'
require 'artrest/build'
require 'artrest/buildnumber'

module ArtRest

    def self.system_info(base_url, options)
        System.info(base_url, options)
    end

    def self.all_builds(base_url, options)
        Builds.get(base_url, options)
    end
end
