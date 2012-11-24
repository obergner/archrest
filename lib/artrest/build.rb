
module ArtRest

    class Build < ArtRest::Resources

        self.mime_type = MIME::Types['application/json']
        self.resources_creator = Proc.new do |content, options|
            self_url = content['uri']
            (content['buildsNumbers'] || []).map { |buildnr| ArtRest::Buildnumber.new("#{self_url}#{buildnr['uri']}", options) }
        end

        resource_attributes :uri,
            :buildsNumbers

        class << self

            protected

            def matches_path(path, options)
                path =~ %r|^/api/build/[a-zA-Z+-._]+/?$|
            end
        end
    end
end
