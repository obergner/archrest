require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Build do

    before(:each) do
        @build_name = 'vnet.sms.common.shell'
        @artbuild   = ArtRest::Build.new @build_name, OPTIONS
        register_stub_request('./build/build_response_correct.txt', "api/build/#{@build_name}")
    end

    it "should iterate over all build runs" do
        expected_number_of_build_runs = 63
        actual_number_of_build_runs = 0
        @artbuild.each_build_run do |build_number, build_run|
            actual_number_of_build_runs += 1 
        end
        actual_number_of_build_runs.should equal expected_number_of_build_runs
    end
    
    it "should expose the uri property" do
        @artbuild.uri.should eq "#{ARTIFACTORY_URL}/api/build/#{@build_name}"
    end

end
