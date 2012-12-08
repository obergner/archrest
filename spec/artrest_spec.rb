require File.expand_path("../spec_helper", __FILE__)

describe ArtRest do

    before(:each) do
        ArtRest.connect(ARTIFACTORY_URL, ARTIFACTORY_USER, ARTIFACTORY_PWD)
    end

    describe "::system" do
        before(:each) do
            register_stub_request('./system/system_response.txt', "api/system")
        end

        it "should allow a shortcut access to system info" do
            system_info = ArtRest.system
            system_info.should be_an_instance_of ArtRest::System
        end
    end

    describe "::builds" do
        before(:each) do
            register_stub_request('./builds/build_api_response_correct.txt', "api/builds")
        end

        it "should allow a shortcut access to builds" do
            builds = ArtRest.builds
            builds.should be_an_instance_of ArtRest::Builds
        end
    end
end
