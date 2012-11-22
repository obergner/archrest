module ArtRest

    class System < ArtRest::Resource

        self.mime_type = MIME::Types['text/plain']

        class << self

            public

            def info(base_url, options)
                System.new("#{base_url}/api/system", options).content
            end

            protected

            def matches_path(path, options)
                path =~ %r|^/api/system/?$|
            end
        end
    end
end
