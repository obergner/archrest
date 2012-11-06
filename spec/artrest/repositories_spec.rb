require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Repositories do

    before(:each) do
        @artrepos = ArtRest::Repositories.new OPTIONS
        register_stub_request('./repositories/repositories_response.txt', "api/repositories")
    end

    it "should iterate over all repositories" do
        expected_number_of_repos = 24
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
