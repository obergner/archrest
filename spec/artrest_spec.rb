require File.expand_path("../spec_helper", __FILE__)

describe ArtRest do

    before(:each) do
        ArtRest.connect(ARTIFACTORY_URL, ARTIFACTORY_USER, ARTIFACTORY_PWD)
        register_stub_request('./system/system_response.txt', "api/system")
    end

    describe "::system" do
        it "should allow a shortcut access to system info" do
            system_info = ArtRest.system
            system_info.should be_an_instance_of String
        end
    end
end
