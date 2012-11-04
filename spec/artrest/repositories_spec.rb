require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Repositories do

    before(:each) do
        @options  = { :artifactory_url => ARTIFACTORY_URL, :artifactory_user => ARTIFACTORY_USER, :artifactory_password => ARTIFACTORY_PWD }
        @artrepos = ArtRest::Repositories.new @options
        @repos_hash = JSON.parse RestClient.get("#{ARTIFACTORY_URL}/api/repositories", {:user => ARTIFACTORY_USER, :password => ARTIFACTORY_PWD })
    end

    it "should iterate over all repositories" do
        expected_number_of_repos = @repos_hash.size
        actual_number_of_repos = 0
        @artrepos.each do |name, repo|
           actual_number_of_repos += 1 
        end
        actual_number_of_repos.should equal expected_number_of_repos
    end
    
    it "should should return each repo as an ArtRest:Repository instance" do
        @artrepos.each do |name, repo|
           repo.should be_an_instance_of ArtRest::Repository 
        end
    end
end
