
module ArtRest

    class Builds < ArtRest::Resources

        self.mime_type = MIME::Types['application/json']
        self.resources_creator = Proc.new do |content, options|
            self_url = content['uri']
            (content['builds'] || []).map { |build| ArtRest::Build.new("#{self_url}#{build['uri']}", options) }
        end

        class << self

            public

            def get(base_url, options)
                Builds.new("#{base_url}/api/build", options)
            end

            protected

            def matches_path(path, options)
                path =~ %r|^/api/build/?$|
            end
        end
    end
end
