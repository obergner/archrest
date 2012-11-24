require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Buildnumber do

    before(:each) do
        @build_name       = 'vnet.sms.common.shell'
        @build_no         = 25
        @buildnumber_path = "api/build/#{@build_name}/#{@build_no}"
        @buildnumber_url  = "#{ARTIFACTORY_URL}/#{@buildnumber_path}"
        @artbuildnumber   = ArtRest::Buildnumber.new(@buildnumber_url, OPTIONS) 
        register_stub_request('./buildnumber/buildnumber_25_response.txt', "#{@buildnumber_path}")
    end

    describe "#url" do
        it "should expose the url property" do
            @artbuildnumber.url.should eq @buildnumber_url
        end
    end

    describe "[all resource attributes]" do

        before(:each) do
            @resource_attributes = [:uri, :buildInfo]
        end

        it "should return a non-nil value" do
            @resource_attributes.each do |attr|
                value = @artbuildnumber.send(attr)
                value.should_not be_nil
            end
        end
    end

    describe "#build_info" do
        context "no block given" do
            it "should return buildInfo as hash" do
                build_info = @artbuildnumber.build_info
                build_info.should_not be_nil
                build_info.should be_an_instance_of Hash
            end
        end

        context "block given" do
            it "should yield buildInfo to block" do
                @artbuildnumber.build_info do |build_info|
                    build_info.should_not be_nil
                    build_info.should be_an_instance_of Hash
                end
            end
        end
    end
end
