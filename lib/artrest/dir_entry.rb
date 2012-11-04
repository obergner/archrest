
module ArtRest

    class DirEntry
        include ArtRest::ResourceMixin

        PROPERTIES = ['path', 'lastUpdated', 'repo', 'uri', 'modifiedBy', 'created', 'createdBy', 'lastModified', 'metadataUri' ]
        
        PROPERTIES.each do |prop|
            self.send :define_method, prop.underscore.to_sym do
                content[prop]
            end
        end
        
        def self.create repo_name, relative_path, options, descriptor_hash
            if descriptor_hash['folder'] or not descriptor_hash['children'].nil? then
                ArtRest::Folder.new repo_name, relative_path, options
            else
                ArtRest::File.new repo_name, relative_path, options
            end
        end

        def to_s
            "#{self.class.name}['#{uri}']"
        end

        protected

        def initialize repo_name, relative_path, options
            check_options options
            @options = options
            @delegate = RestClient::Resource.new "#{url}/api/storage/#{repo_name}#{relative_path}", user, password
        end
    end


    class Folder < ArtRest::DirEntry
        include Enumerable

        def [] relative_path
            entry_json = JSON.parse @delegate[relative_path].get
            ArtRest::DirEntry.create repo, [path, relative_path].join, @options, entry_json 
        end

        def each_child &block
            each &block
        end

        def traverse &block
            each do |child_entry|
                block.call child_entry
                if child_entry.is_a? ArtRest::Folder then
                    child_entry.each_child &block
                end
            end
        end
        
        private

        def each
            content['children'].each do |child_entry|
                yield ArtRest::DirEntry.create repo, [path, child_entry['uri']].join, @options, child_entry
            end
        end
    end

    class File < ArtRest::DirEntry
        
        FILE_PROPS = ['mimeType', 'downloadUri', 'size', 'checksums', 'originalChecksums']
        
        FILE_PROPS.each do |prop|
            self.send :define_method, prop.underscore.to_sym do
                content[prop]
            end
        end
        
    end
end
