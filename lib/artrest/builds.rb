
module ArtRest

    class Builds
        include Enumerable
        include ArtRest::ResourceMixin

        def initialize options
            check_options options
            @options = options
            @delegate = RestClient::Resource.new "#{url}/api/build", user, password
        end

        def uri
            content['uri']
        end

        def each
            content['builds'].each do |build_hash|
                yield [build_hash['uri'], build_hash]
            end
        end
    end
end
