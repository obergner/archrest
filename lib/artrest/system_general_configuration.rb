module ArtRest

    class System

        # Represents Artifactory's {General Configuration}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-GeneralConfiguration]
        # resource. Essentially, this is Artifactory's +artifactory.config.xml+
        # file.
        #
        # This class serves to
        #
        # * retrieve Artifactory's general configuration as an in-memory
        #   XML data structure,
        # * download Artifactory's general configuration to a folder/file, and
        # * update (post) Artifactory's general configuration.
        #
        class GeneralConfiguration < ArtRest::Resource

            class << self
                public

                # Shortcut method to retrieve *the*
                # ArtRest::System::GeneralConfiguration resource.
                #
                # * *Args*    :
                #   - +base_url+ -> Our Artifactory server's base URL
                #   - +options+ -> A Hash containing username and password
                # * *Returns* :
                #   - *The* ArtRest::System::GeneralConfiguration resource
                #
                def get(base_url, options)
                    System::GeneralConfiguration.new("#{base_url}/api/system/configuration", options)
                end

                def matches_path(path, options) # :nodoc:
                    path =~ %r|^/api/system/configuration/?$|
                end
            end

            self.mime_type = MIME::Types['application/xml']

            # Make update! available on this class as it supports updates
            public :update!, :update_with!
        end
    end
end
