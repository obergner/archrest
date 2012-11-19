module ArtRest

    class System < ArtRest::Resource

        self.mime_type = MIME::Types['text/plain']

        class << self

            public

            def info host, options
                System.new("#{host}/api/system", options).content
            end

            protected

            def matches_path path
                path =~ %r|^/api/system/?$|
            end
        end

        def initialize url, options, &block
            super url, options, &block
        end
    end
end
