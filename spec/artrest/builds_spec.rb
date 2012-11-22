require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Builds do

    before(:each) do
        @builds_path = "api/build"
        @builds_url  = "#{ARTIFACTORY_URL}/#{@builds_path}"
        @artbuilds   = ArtRest::Builds.new @builds_url, OPTIONS
        register_stub_request('./builds/build_api_response_correct.txt', @builds_path)
    end

    it "should expose a shortcut method to retrieve all builds" do
        all_builds = ArtRest::Builds.get ARTIFACTORY_URL, OPTIONS
        all_builds.should_not be_nil
        all_builds.should be_an_instance_of ArtRest::Builds
    end
    
    it "should iterate over all builds" do
        expected_number_of_builds = 64
        actual_number_of_builds = 0
        @artbuilds.each do |build|
            actual_number_of_builds += 1 
        end
        actual_number_of_builds.should equal expected_number_of_builds
    end
    
    it "should return all builds as an instance of ArtRest::Build" do
        @artbuilds.each do |build|
            build.should be_an_instance_of ArtRest::Build 
        end
    end
    
    it "should expose the url property" do
        @artbuilds.url.should eq @builds_url
    end

end
