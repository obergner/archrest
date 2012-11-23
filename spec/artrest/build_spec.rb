require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Build do

    before(:each) do
        @build_name = 'vnet.sms.common.shell'
        @build_path = "api/build/#{@build_name}"
        @build_url  = "#{ARTIFACTORY_URL}/#{@build_path}"
        @artbuild   = ArtRest::Build.new @build_url, OPTIONS 
        register_stub_request('./build/build_response_correct.txt', "#{@build_path}")
    end

    describe "#each" do
        it "should iterate over all build numbers" do
            expected_number_of_build_numbers = 63
            actual_number_of_build_numbers = 0
            @artbuild.each do |build_number|
                actual_number_of_build_numbers += 1 
            end
            actual_number_of_build_numbers.should equal expected_number_of_build_numbers
        end
        
        it "should return each build number as an instance of ArtRest::BuildNumber" do
            @artbuild.each do |build_number|
                build_number.should_not be_nil
                build_number.should be_an_instance_of ArtRest::Buildnumber
            end
        end
    end

    describe "#url" do
        it "should expose the url property" do
            @artbuild.url.should eq @build_url
        end
    end
end
