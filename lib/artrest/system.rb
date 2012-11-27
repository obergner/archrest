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
                System.new("#{base_url}/api/system", options)
            end

            def matches_path(path, options) # :nodoc:
                path =~ %r|^/api/system/?$|
            end
        end

        self.mime_type = MIME::Types['text/plain']

        # Get this system resource's {ping}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-SystemHealthPing]
        # subresource, i.e. issue a ping request to test whether the
        # Artifactory server this resource represents is still in a healthy
        # state.
        #
        # Returns the plain RestClient::Response object returned by the server.
        # In case the server is functioning properly this response will carry
        # an HTTP 200 return code, and its body will contain the string
        # "OK". Otherwise, the response returned will carry a return code from
        # the 5xx family, and its body will be a text describing the problem.
        #
        # * *Returns* :
        #   - The plain RestClient::Response object as returned by the server
        #
        def ping
            # Directly accessing the ping resource from this resource contravenes
            # our design. For consistency reasons, we ought to explicitly model
            # this ping resource as e.g. an instance of ArtRest::SystemPing.
            # However, here we try to strike a balance between perfectionism
            # and pragmatism and lean towards the latter.
            RestClient::Resource.new("#{base_url}/api/system/ping", user, password).get
        end

        # Get this system resource's {general configuration}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-GeneralConfiguration]
        # subresource, i.e. the resource representing Artifactory's
        # +artifactory.config.xml+ file.
        #
        # * *Returns* :
        #   - 
        #
        def configuration
            # Directly accessing the ping resource from this resource contravenes
            # our design. For consistency reasons, we ought to explicitly model
            # this ping resource as e.g. an instance of ArtRest::SystemPing.
            # However, here we try to strike a balance between perfectionism
            # and pragmatism and lean towards the latter.
            RestClient::Resource.new("#{base_url}/api/system/ping", user, password).get
        end
    end
end
