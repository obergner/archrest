require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Builds do

    before(:each) do
        @builds_path = "api/build"
        @builds_url  = "#{ARTIFACTORY_URL}/#{@builds_path}"
        @artbuilds   = ArtRest::Builds.new @builds_url, OPTIONS
        register_stub_request('./builds/build_api_response_correct.txt', @builds_path)
    end

    describe "::get" do
        it "should expose a shortcut method to retrieve all builds" do
            all_builds = ArtRest::Builds.get ARTIFACTORY_URL, OPTIONS
            all_builds.should_not be_nil
            all_builds.should be_an_instance_of ArtRest::Builds
        end
    end

    describe "#each" do
        it "should iterate over all builds" do
            expected_number_of_builds = 64
            actual_number_of_builds = 0
            @artbuilds.each do |build|
                actual_number_of_builds += 1 
            end
            actual_number_of_builds.should equal expected_number_of_builds
        end

        it "should return all builds as an instance of ArtRest::Build" do
            @artbuilds.each do |build|
                build.should be_an_instance_of ArtRest::Build 
            end
        end
    end

    describe "[all resource attributes]" do

        before(:each) do
            @resource_attributes = [:uri, :builds]
        end

        context "when no block given" do
            it "should return a non-nil value" do
                @resource_attributes.each do |attr|
                    value = @artbuilds.send(attr)
                    value.should_not be_nil
                end
            end
        end

        context "when block given" do
            it "should yield a non-nil value to that block" do
                @resource_attributes.each do |attr|
                    @artbuilds.send(attr) do |value|
                        value.should_not be_nil
                    end
                end
            end
        end
    end

    describe "#url" do
        it "should expose the url property" do
            @artbuilds.url.should eq @builds_url
        end
    end

end
