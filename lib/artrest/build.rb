
module ArtRest

    class Build < ArtRest::Resources

        self.mime_type = MIME::Types['application/json']
        self.resources_creator = Proc.new do |content, options|
            self_url = content['uri']
            # TODO: Return ArtRest::BuildNumber once it exists
            (content['buildsNumbers'] || []).map { |buildnr| buildnr }
        end

        class << self

            protected

            def matches_path path
                path =~ %r|^/artifactory/api/build/[a-zA-Z+-._]+/?$|
            end
        end

        def initialize url, options, &block
            super url, options, &block
        end
    end
end
