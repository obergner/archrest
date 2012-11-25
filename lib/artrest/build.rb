
module ArtRest

    # Represents an {Artifactory}[http://www.jfrog.com/home/v_artifactory_opensource_overview]
    # {Build Runs}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-BuildRuns]
    # resource.
    #
    # === Example
    #
    #  build = ArtRest::Build.new('http://localhost:8081/artifactory/api/build/wicket', { ... })
    #
    class Build < ArtRest::Resources

        class << self
            protected

            def matches_path(path, options) # :nodoc:
                path =~ %r|^/api/build/[a-zA-Z+-._]+/?$|
            end
        end

        self.mime_type = MIME::Types['application/json']

        self.resources_creator = Proc.new do |content, options|
            self_url = content['uri']
            (content['buildsNumbers'] || []).map { |buildnr| ArtRest::Buildnumber.new("#{self_url}#{buildnr['uri']}", options) }
        end

        self.resource_attributes :uri,
            :buildsNumbers
    end
end
