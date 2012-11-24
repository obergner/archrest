require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Folder do

    before(:each) do
        @repo_name   = 'ext-snapshot-local'
        @folder_path = '/vnet/sms/infrastructure/rpm-elasticsearch'
        @folder_url  = "#{ARTIFACTORY_URL}/api/storage/#{@repo_name}#{@folder_path}"
        @artfolder   = ArtRest::Folder.new @folder_url, OPTIONS
        register_stub_request('./folder/top_folder_response.txt', "api/storage/#{@repo_name}#{@folder_path}")
        register_stub_request('./folder/sub_folder_response.txt', "api/storage/#{@repo_name}#{@folder_path}/1.0.0-SNAPSHOT")
        register_stub_request('./folder/pom_file_response_1.txt', "api/storage/#{@repo_name}#{@folder_path}/1.0.0-SNAPSHOT/rpm-elasticsearch-1.0.0-20120411.155423-1.pom")
    end

    describe "#each" do
        it "should iterate over all child folders" do
            expected_number_of_folders = 1
            actual_number_of_folders = 0
            @artfolder.each do |folder|
                actual_number_of_folders += 1 
            end
            actual_number_of_folders.should equal expected_number_of_folders
        end

        it "should return each child folder as an ArtRest::Folder instance" do
            @artfolder.each do |folder|
                folder.should be_an_instance_of ArtRest::Folder
            end
        end
    end

    describe "[all resource attributes]" do

        before(:each) do
            @resource_attributes = [:path, 
                                    :lastUpdated,
                                    :repo,
                                    :uri,
                                    :modifiedBy,
                                    :created,
                                    :createdBy,
                                    :lastModified,
                                    :metadataUri]
        end

        context "when no block given" do
            it "should return a non-nil value" do
                @resource_attributes.each do |attr|
                    value = @artfolder.send(attr)
                    value.should_not be_nil
                end
            end
        end

        context "when block given" do
            it "should yield a non-nil value to that block" do
                @resource_attributes.each do |attr|
                    @artfolder.send(attr) do |value|
                        value.should_not be_nil
                    end
                end
            end
        end
    end

    describe "#[]" do
        it "should return a subfolder as an instance of ArtRest::Folder" do
            folder = @artfolder['1.0.0-SNAPSHOT']
            folder.should_not be_nil
            folder.should be_an_instance_of ArtRest::Folder
        end

        it "should return a contained artifact as an instance of ArtRest::Artifact" do
            artifact = @artfolder['1.0.0-SNAPSHOT/rpm-elasticsearch-1.0.0-20120411.155423-1.pom']
            artifact.should_not be_nil
            artifact.should be_an_instance_of ArtRest::Artifact
        end
    end

    describe "#traverse" do
        it "should traverse the whole subtree rooted at itself" do
            @artfolder.traverse do |child|
                child.should be_a_kind_of ArtRest::DirEntry
            end
        end
    end

end
