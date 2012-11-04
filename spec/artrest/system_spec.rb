require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::System do

    before(:each) do
        @options = { :artifactory_url => ARTIFACTORY_URL, :artifactory_user => ARTIFACTORY_USER, :artifactory_password => ARTIFACTORY_PWD }
        @artsys  = ArtRest::System.new @options
    end

    it "should output system info as text" do
        @artsys.to_s.should_not be_nil
        @artsys.to_s.should be_an_instance_of String
    end
end
