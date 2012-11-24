
module ArtRest

    class Repository < ArtRest::Resources

        self.mime_type = MIME::Types['application/json']
        self.resources_creator = Proc.new do |content, options|
            self_url = content['uri']
            (content['children'] || []).map { |child| ArtRest::DirEntry.create_node("#{self_url}#{child['uri']}", options, child) }
        end

        resource_attributes :path, 
            :lastUpdated,
            :repo,
            :uri,
            :modifiedBy,
            :created,
            :createdBy,
            :lastModified,
            :metadataUri,
            :children

        class << self

            protected

            def matches_path(path, options)
                path =~ %r|^/api/storage/[a-zA-Z+-._]+/?$|
            end
        end
    end
end
