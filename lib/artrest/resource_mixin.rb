
module ArtRest

    module ResourceMixin

        def delete
            @delegate.delete
        end

        private

        def content
            return @content if @content
            raw = @delegate.get
            begin
                @content = JSON.parse raw
            rescue JSON::ParserError
                @content = raw
            end
            @content
        end

        def check_options options
            raise ArgumentError, "Must pass :artifactory_url" unless options[:artifactory_url]
            raise ArgumentError, "Must pass :artifactory_user" unless options[:artifactory_user]
            raise ArgumentError, "Must pass :artifactory_password" unless options[:artifactory_password]
        end

        def options
            @options
        end

        def url
            @options[:artifactory_url]
        end

        def user
            @options[:artifactory_user]
        end

        def password
            @options[:artifactory_password]
        end
    end
end
