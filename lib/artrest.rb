require 'uri'
require 'rest-client'
require 'json'
require 'mime/types'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/class/attribute'

require 'artrest/version'
require 'artrest/resource'
require 'artrest/resources'
require 'artrest/resource_mixin'
require 'artrest/system'
require 'artrest/repositories'
require 'artrest/repository'
require 'artrest/dir_entry'
require 'artrest/builds'
require 'artrest/build'

module ArtRest

    def self.system_info host, options
        System.info host, options
    end

    def self.all_builds options
        Builds.get options
    end
end
