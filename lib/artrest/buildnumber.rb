
module ArtRest

    class Buildnumber < ArtRest::Resource

        self.mime_type = MIME::Types['application/json']

        resource_attributes :uri, 
            :buildInfo

        class << self
            protected

            def matches_path(path, options)
                path =~ %r|^/api/build/[a-zA-Z+-._]+/\d+$|
            end
        end

        def build_info
            yield content['buildInfo'] if block_given?
            content['buildInfo']
        end
    end
end
