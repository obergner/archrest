require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::System::GeneralConfiguration do

    before(:each) do
        @artsys_config_url = "#{ARTIFACTORY_URL}/api/system/configuration"
        @artsys_config  = ArtRest::System::GeneralConfiguration.new(@artsys_config_url, OPTIONS)
        register_stub_request('./system/general_configuration_response.txt', "api/system/configuration")
    end

    describe "::get" do
        it "should allow a shortcut to access Artifactory's general configuration" do
            general_config = ArtRest::System::GeneralConfiguration.get(ARTIFACTORY_URL, OPTIONS)
            general_config.should be_an_instance_of ArtRest::System::GeneralConfiguration
        end
    end

    describe "#content" do
        it "should return configuration as a String" do
            content = @artsys_config.content
            content.should be_an_instance_of String
        end
    end

    describe "#update!" do

        before(:each) do
            @authenticated_artsys_config_url = @artsys_config_url.
                gsub('http://', "http://#{ARTIFACTORY_USER}:#{ARTIFACTORY_PWD}@")
            @updated_configuration = 'UPDATED'
            stub_request(:post, @authenticated_artsys_config_url).
                with(:body => @updated_configuration).
                to_return(:status => 200, :body => "", :headers => {})
        end

        after(:each) do
            a_request(:post, @authenticated_artsys_config_url).
                with(:body => @updated_configuration).should have_been_made.once            
        end

        it "should post updated system configuration" do
            @artsys_config.content = @updated_configuration
            @artsys_config.update!
        end
    end

    describe "#update_with!" do

        before(:each) do
            @authenticated_artsys_config_url = @artsys_config_url.
                gsub('http://', "http://#{ARTIFACTORY_USER}:#{ARTIFACTORY_PWD}@")
            @updated_configuration = 'UPDATED'
            stub_request(:post, @authenticated_artsys_config_url).
                with(:body => @updated_configuration).
                to_return(:status => 200, :body => "", :headers => {})
        end

        after(:each) do
            a_request(:post, @authenticated_artsys_config_url).
                with(:body => @updated_configuration).should have_been_made.once            
        end

        it "should accept provided content as resource's new content" do
            @artsys_config.update_with!(@updated_configuration)
            @artsys_config.content.should == @updated_configuration
        end
        
        it "should post updated system configuration" do
            @artsys_config.update_with!(@updated_configuration)
        end
    end
end
