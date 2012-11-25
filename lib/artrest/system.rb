module ArtRest

    # Represents the {Artifactory}[http://www.jfrog.com/home/v_artifactory_opensource_overview]
    # {System}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-SystemInfo]
    # resource. Its content is a formatted multiline string listing
    #
    # * Java version used
    # * Memory consumption
    # * ...
    #
    # === Example
    #
    #  sysInfo = ArtRest::System.new('http://localhost:8081/artifactory/api/system', { ... })
    #
    class System < ArtRest::Resource

        class << self
            public

            # Shortcut method to retrieve *the* ArtRest::System resource.
            #
            # * *Args*    :
            #   - +base_url+ -> Our Artifactory server's base URL
            #   - +options+ -> A Hash containing username and password
            # * *Returns* :
            #   - *The* ArtRest::System resource
            #
            def get(base_url, options)
                System.new("#{base_url}/api/system", options).content
            end

            protected

            def matches_path(path, options) # :nodoc:
                path =~ %r|^/api/system/?$|
            end
        end

        self.mime_type = MIME::Types['text/plain']
    end
end
