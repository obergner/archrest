
module ArtRest

    module DirEntry

        PROPERTIES = ['path', 'lastUpdated', 'repo', 'uri', 'modifiedBy', 'created', 'createdBy', 'lastModified', 'metadataUri' ]
        PROPERTIES.each do |prop|
            self.send(:define_method, prop.underscore.to_sym) do
                content[prop]
            end
        end

        def self.create_node(resource_url, options, resource_descriptor, &block)
            if resource_descriptor['folder'] or not resource_descriptor['children'].nil? then
                ArtRest::Folder.new(resource_url, options, &block)
            else
                ArtRest::Artifact.new(resource_url, options, &block)
            end
        end
    end


    class Folder < ArtRest::Resources
        include ArtRest::DirEntry

        self.mime_type = MIME::Types['application/json']
        self.resources_creator = Proc.new do |content, options|
            self_url = content['uri']
            (content['children'] || []).map { |child| ArtRest::DirEntry.create_node("#{self_url}#{child['uri']}", options, child) }
        end

        class << self
            protected

            def matches_path(path, options)
                return false unless path =~ %r|^/api/storage/[a-zA-Z0-9_.+-]+/.+$|
                content_hash = JSON.parse(RestClient::Resource.new([options[:base_url], path].join, options[:user], options[:password]).get)
                return content_hash['children']
            end
        end

        public

        def [](suburl, &new_block)
            subresource_content = JSON.parse(RestClient::Resource.new(url, options, &new_block)[suburl].get)
            ArtRest::DirEntry.create_node([url, suburl].join, options, subresource_content, &new_block) 
        end

        def traverse(&block)
            each do |child_entry|
                block.call(child_entry)
                if child_entry.is_a?(ArtRest::Folder) then
                    child_entry.each &block
                end
            end
        end
    end

    class Artifact < ArtRest::Resource
        include ArtRest::DirEntry

        FILE_PROPS = ['mimeType', 'downloadUri', 'size', 'checksums', 'originalChecksums']
        FILE_PROPS.each do |prop|
            self.send(:define_method, prop.underscore.to_sym) do
                content[prop]
            end
        end

        self.mime_type = MIME::Types['application/json']

        class << self
            protected

            def matches_path(path, options)
                return false unless path =~ %r|^/api/storage/[a-zA-Z0-9_.+-]+/.+$|
                content_hash = JSON.parse(RestClient::Resource.new([options[:base_url], path].join, options[:user], options[:password]).get)
                return ! content_hash['children']
            end
        end

        public

        def [](suburl, &new_block)
            raise NotImplementedError.new("Instances of ArtRest::Artifact don't have child resources")
        end
    end
end
