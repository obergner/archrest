
module ArtRest

    class Builds
        include Enumerable
        include ArtRest::ResourceMixin

        def self.get options
            Builds.new options
        end

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
                build_name = build_hash['uri'][1..-1]
                yield [build_name, ArtRest::Build.new(build_name, @options)]
            end
        end
    end
end
