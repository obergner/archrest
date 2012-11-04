
module ArtRest

    class Repository
        include Enumerable
        include ArtRest::ResourceMixin

        PROPERTIES = ['path', 'lastUpdated', 'repo', 'uri', 'modifiedBy', 'created', 'createdBy', 'lastModified', 'metadataUri' ]

        PROPERTIES.each do |prop|
            self.send :define_method, prop.underscore.to_sym do
                content[prop]
            end
        end

        def initialize name, options
            check_options options
            @options = options
            @delegate = RestClient::Resource.new "#{url}/api/storage/#{name}", user, password
        end

        def each_folder &block
            each &block
        end

        private

        def each
            content['children'].each do |dir_entry_hash|
                yield dir_entry_hash
            end
        end
    end
end
