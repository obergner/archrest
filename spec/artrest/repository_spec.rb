require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Repository do

    before(:each) do
        @repo_name  = 'libs-snapshot-local'
        @repo_url   = "#{ARTIFACTORY_URL}/api/storage/#{@repo_name}"
        @artrepo    = ArtRest::Repository.new(@repo_url, OPTIONS)
        register_stub_request('./repository/libs_snapshot_local_response.txt', "api/storage/#{@repo_name}")
    end

    describe "#each" do
        it "should iterate over all folders" do
            expected_number_of_folders = 1
            actual_number_of_folders = 0
            @artrepo.each do |folder|
                actual_number_of_folders += 1 
            end
            actual_number_of_folders.should equal expected_number_of_folders
        end
        
        it "should return each folder as an instance of ArtRest::Folder" do
            @artrepo.each do |folder|
                folder.should be_an_instance_of ArtRest::Folder
            end
        end
    end
end
