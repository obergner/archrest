require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::System do

    before(:each) do
        @artsys  = ArtRest::System.new OPTIONS
        register_stub_request('./system/system_response.txt', "api/system")
    end

    it "should output system info as text" do
        @artsys.to_s.should_not be_nil
        @artsys.to_s.should be_an_instance_of String
    end

    it "should allow a shortcut to access system info" do
        system_info = ArtRest::System.info OPTIONS
        system_info.should_not be_nil
        system_info.should be_an_instance_of String
    end
end
