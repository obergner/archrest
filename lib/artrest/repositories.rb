
module ArtRest

    class Repositories < ArtRest::Resources

        self.mime_type = MIME::Types['application/json']
        self.resources_creator = Proc.new do |content, options|
            content.map { |repo| ArtRest::Repository.new(repo['url'], options) }
        end

        class << self

            public

            def get(base_url, options)
                Repositories.new("#{base_url}/api/repositories", options)
            end

            protected

            def matches_path(path, options)
                path =~ %r|^/api/repositories/?$|
            end
        end
    end
end
