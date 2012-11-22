require File.expand_path("../spec_helper", __FILE__)

describe ArtRest do

    before(:each) do
        register_stub_request('./system/system_response.txt', "api/system")
    end

    describe "::info" do
        it "should allow a shortcut access to system info" do
            system_info = ArtRest.system_info(ARTIFACTORY_URL, OPTIONS)
            system_info.should_not be_nil
            system_info.should be_an_instance_of String
        end
    end
end
