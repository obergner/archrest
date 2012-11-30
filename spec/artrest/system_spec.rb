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
            system_info.should be_an_instance_of ArtRest::System
        end
    end

    describe "#to_s" do
        it "should output system info as text" do
            @artsys.to_s.should be_an_instance_of String
        end
    end

    describe "#ping" do

        context "when server is healthy" do
            before(:each) do
                register_stub_request('./system/200_OK_ping_response.txt', "api/system/ping")
            end

            it "should return response carrying HTTP code 200" do
                ping_response = @artsys.ping
                ping_response.code.should eq 200
            end
        end
    end

    describe "#configuration" do

        before(:each) do
            @artsys_config_url = "#{ARTIFACTORY_URL}/api/system/configuration"
            @artsys_config  = ArtRest::System::GeneralConfiguration.new(@artsys_config_url, OPTIONS)
            register_stub_request('./system/general_configuration_response.txt', "api/system/configuration")
        end

        it "should return Artifactory's general configuration as an ArtRest::System::GeneralConfiguration instance" do
            @artsys.configuration.should be_an_instance_of ArtRest::System::GeneralConfiguration
        end
    end
end
