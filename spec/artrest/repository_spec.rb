require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Repository do

    before(:each) do
        @repo_name  = 'libs-snapshot-local'
        @repo_url   = "#{ARTIFACTORY_URL}/api/storage/#{@repo_name}"
        @artrepo    = ArtRest::Repository.new(@repo_url, OPTIONS)
        register_stub_request('./repository/libs_snapshot_local_response.txt', "api/storage/#{@repo_name}")
    end

    describe "#each" do
        it "should iterate over all folders" do
            expected_number_of_folders = 1
            actual_number_of_folders = 0
            @artrepo.each do |folder|
                actual_number_of_folders += 1 
            end
            actual_number_of_folders.should equal expected_number_of_folders
        end

        it "should return each folder as an instance of ArtRest::Folder" do
            @artrepo.each do |folder|
                folder.should be_an_instance_of ArtRest::Folder
            end
        end
    end

    describe "[all resource attributes]" do

        before(:each) do
            @resource_attributes = [:path,
                                    :lastUpdated,
                                    :repo,
                                    :uri,
                                    :modifiedBy,
                                    :created,
                                    :createdBy,
                                    :lastModified,
                                    :metadataUri,
                                    :children]
        end

        context "when no block given" do
            it "should return a non-nil value" do
                @resource_attributes.each do |attr|
                    value = @artrepo.send(attr)
                    value.should_not be_nil
                end
            end
        end

        context "when block given" do
            it "should yield a non-nil value to that block" do
                @resource_attributes.each do |attr|
                    @artrepo.send(attr) do |value|
                        value.should_not be_nil
                    end
                end
            end
        end
    end
end
