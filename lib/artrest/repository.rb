
module ArtRest

    # Represents an {Artifactory}[http://www.jfrog.com/home/v_artifactory_opensource_overview]
    # repository resource.
    #
    # *IMPORTANT* This is *not* the {Repository Configuration}[http://wiki.jfrog.org/confluence/display/RTF/Artifactory's+REST+API#Artifactory'sRESTAPI-RepositoryConfiguration]
    # resource as this would require Artifactory Pro. It is rather a repository's
    # top-level {folder}[rdoc-ref:ArtRest::Folder] "/".
    #
    # === Example
    #
    #  libs_releas_local = ArtRest::Repository.new('http://localhost:8081/artifactory/api/storage/libs-release-local', { ... })
    #
    class Repository < ArtRest::Resources

        class << self

            def matches_path(path, options) # :nodoc:
                path =~ %r|^/api/storage/[a-zA-Z+-._]+/?$|
            end
        end

        self.mime_type = MIME::Types['application/json']

        self.resources_creator = Proc.new do |content, options|
            self_url = content['uri']
            (content['children'] || []).map { |child| ArtRest::DirEntry.create_node("#{self_url}#{child['uri']}", options, child) }
        end

        self.resource_attributes :path, 
            :lastUpdated,
            :repo,
            :uri,
            :modifiedBy,
            :created,
            :createdBy,
            :lastModified,
            :metadataUri,
            :children
    end
end
