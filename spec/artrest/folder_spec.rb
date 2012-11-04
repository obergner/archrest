require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Folder do

    before(:each) do
        @repo_name   = 'libs-snapshot-local'
        @folder_path = '/vnet/sms/common'
        @options     = { :artifactory_url => ARTIFACTORY_URL, :artifactory_user => ARTIFACTORY_USER, :artifactory_password => ARTIFACTORY_PWD }
        @artfolder   = ArtRest::DirEntry.create @repo_name, @folder_path, @options, { 'uri' => '/common', 'folder' => true }
        @folder_hash = JSON.parse RestClient.get("#{ARTIFACTORY_URL}/api/storage/#{@repo_name}#{@folder_path}", {:user => ARTIFACTORY_USER, :password => ARTIFACTORY_PWD })
    end

    it "should iterate over all child folders" do
        expected_number_of_folders = @folder_hash['children'].size
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
        @artfolder['cassandra-cachewriter/1.0.0-SNAPSHOT'].should_not be_nil
    end

    it "should traverse the whole subtree rooted at itself" do
        @artfolder.traverse do |child|
            child.should be_a_kind_of ArtRest::DirEntry
        end
    end

end
