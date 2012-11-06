require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Repository do

    before(:each) do
        @repo_name  = 'libs-snapshot-local'
        @artrepo    = ArtRest::Repository.new @repo_name, OPTIONS
        register_stub_request('./repository/libs_snapshot_local_response.txt', "api/storage/#{@repo_name}")
    end

    it "should iterate over all folders" do
        expected_number_of_folders = 1
        actual_number_of_folders = 0
        @artrepo.each_folder do |folder|
           actual_number_of_folders += 1 
        end
        actual_number_of_folders.should equal expected_number_of_folders
    end
    
    it "should expose the createdBy property" do
        @artrepo.created_by.should eq '_system_'
    end
end
