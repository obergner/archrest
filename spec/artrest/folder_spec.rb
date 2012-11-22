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

    describe "#modified_by" do
        it "should expose the modifiedBy property" do
            @artfolder.modified_by.should eq 'admin'
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
