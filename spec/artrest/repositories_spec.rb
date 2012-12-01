require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Repositories do

    before(:each) do
        @repos_url = "#{ARTIFACTORY_URL}/api/repositories"
        @artrepos = ArtRest::Repositories.new(@repos_url, OPTIONS)
        register_stub_request('./repositories/repositories_response.txt', "api/repositories")
    end

    describe "::get" do
        it "should return an ArtRest::Repositories instance" do
            repositories = ArtRest::Repositories.get(ARTIFACTORY_URL, OPTIONS)
            repositories.should be_an_instance_of ArtRest::Repositories
        end
    end

    describe "#each" do
        it "should iterate over all repositories" do
            expected_number_of_repos = 24
            actual_number_of_repos = 0
            @artrepos.each do |repo|
                actual_number_of_repos += 1 
            end
            actual_number_of_repos.should equal expected_number_of_repos
        end

        it "should should return each repo as an ArtRest:Repository instance" do
            @artrepos.each do |repo|
                repo.should be_an_instance_of ArtRest::Repository 
            end
        end
    end

    describe "#repository" do

        before(:each) do
            @repo_name = 'libs-snapshot-local'
            register_stub_request('./repositories/libs_snapshot_local_folder_response.txt', "api/storage/#{@repo_name}/")
        end

        it "should return requested repository as an ArtRest::Repository instance" do
            repo = @artrepos.repository(@repo_name)
            repo.should be_an_instance_of ArtRest::Repository
        end
    end
end
