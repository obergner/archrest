require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::System do

    before(:each) do
        @artsys_url = "#{ARTIFACTORY_URL}/api/system"
        @artsys  = ArtRest::System.new(@artsys_url, OPTIONS)
        register_stub_request('./system/system_response.txt', "api/system")
    end

    describe "::get" do
        it "should allow a shortcut to access system info" do
            system_info = ArtRest::System.get(ARTIFACTORY_URL, OPTIONS)
            system_info.should_not be_nil
            system_info.should be_an_instance_of String
        end
    end

    describe "#to_s" do
        it "should output system info as text" do
            @artsys.to_s.should_not be_nil
            @artsys.to_s.should be_an_instance_of String
        end
    end
end
