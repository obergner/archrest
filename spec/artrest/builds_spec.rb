require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Builds do

    before(:each) do
        @artbuilds   = ArtRest::Builds.new OPTIONS
        register_stub_request('./builds/build_api_response_correct.txt', "api/build")
    end

    it "should iterate over all builds" do
        expected_number_of_builds = 64
        actual_number_of_builds = 0
        @artbuilds.each do |build|
            actual_number_of_builds += 1 
        end
        actual_number_of_builds.should equal expected_number_of_builds
    end
    
    it "should expose the uri property" do
        @artbuilds.uri.should eq "#{ARTIFACTORY_URL}/api/build"
    end

end
