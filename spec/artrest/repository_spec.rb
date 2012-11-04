require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Repository do

    before(:each) do
        @repo_name  = 'libs-snapshot-local'
        @options    = { :artifactory_url => ARTIFACTORY_URL, :artifactory_user => ARTIFACTORY_USER, :artifactory_password => ARTIFACTORY_PWD }
        @artrepo    = ArtRest::Repository.new @repo_name, @options
        @repo_hash  = JSON.parse RestClient.get("#{ARTIFACTORY_URL}/api/storage/#{@repo_name}", {:user => ARTIFACTORY_USER, :password => ARTIFACTORY_PWD })
    end

    it "should iterate over all folders" do
        expected_number_of_folders = @repo_hash['children'].size
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
