
module ArtRest

    class Builds < ArtRest::Resources

        self.mime_type = MIME::Types['application/json']
        self.resources_creator = Proc.new do |content, options|
            self_url = content['uri']
            (content['builds'] || []).map { |build| ArtRest::Build.new "#{self_url}#{build['uri']}", options }
        end

        class << self

            public

            def get host, options
                Builds.new "#{host}/api/build", options
            end

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
