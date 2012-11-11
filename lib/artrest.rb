require 'rest-client'
require 'json'
require 'active_support/core_ext/string/inflections'

require 'artrest/version'
require 'artrest/resource_mixin'
require 'artrest/system'
require 'artrest/repositories'
require 'artrest/repository'
require 'artrest/dir_entry'
require 'artrest/builds'
require 'artrest/build'

module ArtRest

    def self.system_info options
        System.info options
    end

    def self.all_builds options
        Builds.get options
    end
end
