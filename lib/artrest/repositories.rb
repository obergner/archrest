
module ArtRest

    class Repositories
        include Enumerable
        include ArtRest::ResourceMixin

        def initialize options
            check_options options
            @options = options
            @delegate = RestClient::Resource.new "#{url}/api/repositories", user, password
        end

        def each
            content.each do |repo_hash|
                yield [repo_hash['key'], ArtRest::Repository.new(repo_hash['key'], @options)]
            end
        end
    end
end
