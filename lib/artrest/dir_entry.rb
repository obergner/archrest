
module ArtRest

    module DirEntry

        def self.create_node(resource_url, options, resource_descriptor, &block)
            if resource_descriptor['folder'] or not resource_descriptor['children'].nil?
                ArtRest::Folder.new(resource_url, options, &block)
            else
                ArtRest::Artifact.new(resource_url, options, &block)
            end
        end
    end


    # Represents an {Artifactory}[http://www.jfrog.com/home/v_artifactory_opensource_overview]
    # {Folder Info}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-FolderInfo]
    # resource.
    #
    # === Example
    #
    #  folder = ArtRest::Folder.new('http://localhost:8081/artifactory/api/storage/libs-release-local/commons-lang/commons-lang', { ... })
    #
    class Folder < ArtRest::Resources
        include ArtRest::DirEntry

        class << self
            protected

            def matches_path(path, options) # :nodoc:
                return false unless path =~ %r|^/api/storage/[a-zA-Z0-9_.+-]+/.+$|
                    content_hash = JSON.parse(RestClient::Resource.new([options[:base_url], path].join, options[:user], options[:password]).get)
                return content_hash['children']
            end
        end

        self.mime_type = MIME::Types['application/json']

        self.resources_creator = Proc.new do |content, options|
            (content['children'] || []).map { |child| ArtRest::DirEntry.create_node("#{content['uri']}#{child['uri']}", options, child) }
        end

        self.resource_attributes :path, 
            :lastUpdated,
            :repo,
            :uri,
            :modifiedBy,
            :created,
            :createdBy,
            :lastModified,
            :metadataUri

        public

        def [](suburl, &new_block) # :nodoc:
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

    # Represents an {Artifactory}[http://www.jfrog.com/home/v_artifactory_opensource_overview]
    # {File Info}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-FileInfo]
    # resource.
    #
    # === Example
    #
    #  file = ArtRest::File.new('http://localhost:8081/artifactory/api/storage/libs-release-local/commons-lang/commons-lang/3.2/commons-lang-3.2.jar', { ... })
    #
    class Artifact < ArtRest::Resource
        include ArtRest::DirEntry

        class << self
            protected

            def matches_path(path, options) # :nodoc:
                return false unless path =~ %r|^/api/storage/[a-zA-Z0-9_.+-]+/.+$|
                    content_hash = JSON.parse(RestClient::Resource.new([options[:base_url], path].join, options[:user], options[:password]).get)
                return ! content_hash['children']
            end
        end

        self.mime_type = MIME::Types['application/json']

        self.resource_attributes :path,
            :lastUpdated,
            :repo,
            :uri,
            :modifiedBy,
            :created,
            :createdBy,
            :lastModified,
            :metadataUri,
            :mimeType,
            :downloadUri,
            :size,
            :checksums,
            :originalChecksums

        public

        # Overwritten to always throw NotImplementedError since ArtRest::Artifacts
        # don't have sub resources.
        #
        def [](suburl, &new_block)
            raise NotImplementedError.new("Instances of ArtRest::Artifact don't have child resources")
        end
    end
end
