
module ArtRest

    # Represents an {Artifactory}[http://www.jfrog.com/home/v_artifactory_opensource_overview]
    # {Repositories}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-GetRepositories]
    # resource.
    #
    # === Example
    #
    #  repos = ArtRest::Repositories.new('http://localhost:8081/artifactory/api/repositories', { ... })
    #
    class Repositories < ArtRest::Resources

        class << self
            public

            # Shortcut method to retrieve *the* ArtRest::Repositories
            # instance.
            #
            # * *Args*    :
            #   - +base_url+ -> Our Artifactory server's base URL
            #   - +options+ -> A Hash containing username and password
            # * *Returns* :
            #   - *The* ArtRest::Repositories instance representing the
            #     collection of all Artifactory repositories
            #
            def get(base_url, options)
                Repositories.new("#{base_url}/api/repositories", options)
            end

            def matches_path(path, options) # :nodoc:
                path =~ %r|^/api/repositories/?$|
            end
        end

        self.mime_type = MIME::Types['application/json']

        self.resources_creator = Proc.new do |content, options|
            content.map { |repo| ArtRest::Repository.new(repo['url'], options) }
        end

        # Look up and return the repository[rdoc-ref:ArtRest::Repository] named
        # +repo_name+. Optionally yield that repository to a block provided a 
        # block is given. 
        #
        # * *Args*    :
        #  [+repo_name+] Name of the repository to return
        # * *Returns* :
        #   - The repository named +repo_name+, an ArtRest::Repository instance
        # * *Raises* :
        #  [+RestClient::ResourceNotFound+] If +repo_name+ does not point to an
        #                                   existing repository
        #
        def repository(repo_name) # :yields: repository
            repo_url = concat_urls(base_url, "/#{repo_name}/")
            repo = ArtRest::Repository.new(repo_url, options, block)
            yield repo if block_given?
            repo
        end
    end
end
