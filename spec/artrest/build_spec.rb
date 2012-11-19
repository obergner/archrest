require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Build do

    before(:each) do
        @options    = { :user => ARTIFACTORY_USER, :password => ARTIFACTORY_PWD }
        @build_name = 'vnet.sms.common.shell'
        @build_path = "api/build/#{@build_name}"
        @build_url  = "#{ARTIFACTORY_URL}/#{@build_path}"
        @artbuild   = ArtRest::Build.new @build_url, @options
        register_stub_request('./build/build_response_correct.txt', "#{@build_path}")
    end

    it "should iterate over all build runs" do
        expected_number_of_build_runs = 63
        actual_number_of_build_runs = 0
        @artbuild.each do |build_number|
            actual_number_of_build_runs += 1 
        end
        actual_number_of_build_runs.should equal expected_number_of_build_runs
    end
    
    it "should expose the url property" do
        @artbuild.url.should eq @build_url
    end

end
