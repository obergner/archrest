
module ArtRest

    # Represents an {Artifactory}[http://www.jfrog.com/home/v_artifactory_opensource_overview]
    # {Build Info}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-BuildInfo]
    # resource.
    #
    # === Example
    #
    #  buildInfo = ArtRest::Buildnumber.new('http://localhost:8081/artifactory/api/build/wicket/51', { ... })
    #
    class Buildnumber < ArtRest::Resource

        class << self
            protected

            def matches_path(path, options) # :nodoc:
                path =~ %r|^/api/build/[a-zA-Z+-._]+/\d+$|
            end
        end

        self.mime_type = MIME::Types['application/json']

        self.resource_attributes :uri,
            :buildInfo
    end
end
