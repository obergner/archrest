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

        context "when no block given" do
            it "should return a non-nil value" do
                @resource_attributes.each do |attr|
                    value = @artbuildnumber.send(attr)
                    value.should_not be_nil
                end
            end
        end

        context "when block given" do
            it "should yield a non-nil value to that block" do
                @resource_attributes.each do |attr|
                    @artbuildnumber.send(attr) do |value|
                        value.should_not be_nil
                    end
                end
            end
        end
    end
end
