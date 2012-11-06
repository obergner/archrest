require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Folder do

    before(:each) do
        @repo_name   = 'ext-snapshot-local'
        @folder_path = '/vnet/sms/infrastructure/rpm-elasticsearch'
        @artfolder   = ArtRest::DirEntry.create @repo_name, @folder_path, OPTIONS, { 'uri' => '/common', 'folder' => true }
        register_stub_request('./folder/top_folder_response.txt', "api/storage/#{@repo_name}#{@folder_path}")
        register_stub_request('./folder/sub_folder_response.txt', "api/storage/#{@repo_name}#{@folder_path}/1.0.0-SNAPSHOT")
        register_stub_request('./folder/sub_folder_response.txt', "api/storage/#{@repo_name}#{@folder_path}/1.0.0-SNAPSHOT/rpm-elasticsearch-1.0.0-20120411.155423-1.pom")
    end

    it "should iterate over all child folders" do
        expected_number_of_folders = 1
        actual_number_of_folders = 0
        @artfolder.each_child do |folder|
            actual_number_of_folders += 1 
        end
        actual_number_of_folders.should equal expected_number_of_folders
    end

    it "should return each child folder as an ArtRest::Folder instance" do
        @artfolder.each_child do |folder|
            folder.should be_an_instance_of ArtRest::Folder
        end
    end

    it "should expose the modifiedBy property" do
        @artfolder.modified_by.should eq 'admin'
    end

    it "should allow hash-like access to subentries" do
        @artfolder['1.0.0-SNAPSHOT/rpm-elasticsearch-1.0.0-20120411.155423-1.pom'].should_not be_nil
    end

    it "should traverse the whole subtree rooted at itself" do
        @artfolder.traverse do |child|
            child.should be_a_kind_of ArtRest::DirEntry
        end
    end

end
