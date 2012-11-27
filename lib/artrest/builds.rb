
module ArtRest

    # Represents an {Artifactory}[http://www.jfrog.com/home/v_artifactory_opensource_overview]
    # {All Builds}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-AllBuilds]
    # resource.
    #
    # === Example
    #
    #  allBuilds = ArtRest::Builds.new('http://localhost:8081/artifactory/api/build', { ... })
    #
    class Builds < ArtRest::Resources

        class << self
            public

            # Shortcut method to retrieve *the* ArtRest::Builds
            # instance.
            #
            # * *Args*    :
            #   - +base_url+ -> Our Artifactory server's base URL
            #   - +options+ -> A Hash containing username and password
            # * *Returns* :
            #   - *The* ArtRest::Builds instance representing the
            #     collection of all Artifactory builds
            #
            def get(base_url, options)
                Builds.new("#{base_url}/api/build", options)
            end

            def matches_path(path, options) # :nodoc:
                path =~ %r|^/api/build/?$|
            end
        end

        self.mime_type = MIME::Types['application/json']

        self.resources_creator = Proc.new do |content, options|
            self_url = content['uri']
            (content['builds'] || []).map { |build| ArtRest::Build.new("#{self_url}#{build['uri']}", options) }
        end

        self.resource_attributes :uri, 
            :builds
    end
end
