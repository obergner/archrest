module ArtRest

    class System
        include ArtRest::ResourceMixin

        def self.info options
            System.new(options).to_s
        end

        def initialize options
            check_options options
            @options = options
            @delegate = RestClient::Resource.new "#{url}/api/system", user, password
        end

        def to_s
            content
        end
    end
end
