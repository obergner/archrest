
module ArtRest

    class Build
        include Enumerable
        include ArtRest::ResourceMixin

        def initialize build_name, options
            check_options options
            @options  = options
            @name     = build_name
            @delegate = RestClient::Resource.new "#{url}/api/build/#{build_name}", user, password
        end

        def name
            @name
        end

        def uri
            content['uri']
        end

        def each_build_run &block
            each &block
        end

        private

        def each
            content['buildsNumbers'].each do |build_hash|
                yield [name, build_hash]
            end
        end
    end
end
