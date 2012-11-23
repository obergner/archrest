require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Resource do

    describe "::create" do
        before(:each) do
            @system_url = "#{ARTIFACTORY_URL}/api/system"
            register_stub_request('./resource/system_response.txt', "api/system")

            @builds_url = "#{ARTIFACTORY_URL}/api/build"
            register_stub_request('./resource/builds_response.txt', "api/build")

            @build_url = "#{ARTIFACTORY_URL}/api/build/vnet.sms.common.shell"
            register_stub_request('./resource/build_response.txt', "api/build/vnet.sms.common.shell")

            @buildnumber_url = "#{ARTIFACTORY_URL}/api/build/vnet.sms.common.shell/25"
            register_stub_request('./resource/buildnumber_response.txt', "api/build/vnet.sms.common.shell/25")

            @repositories_url = "#{ARTIFACTORY_URL}/api/repositories"
            register_stub_request('./resource/repositories_response.txt', "api/repositories")

            @repository_url = "#{ARTIFACTORY_URL}/api/storage/libs-snapshot-local"
            register_stub_request('./resource/repository_response.txt', "api/storage/libs-snapshot-local")

            @folder_url = "#{ARTIFACTORY_URL}/api/storage/ext-snapshot-local/vnet/sms/infrastructure/rpm-elasticsearch/1.0.0-SNAPSHOT"
            register_stub_request('./resource/folder_response.txt', 
                                  'api/storage/ext-snapshot-local/vnet/sms/infrastructure/rpm-elasticsearch/1.0.0-SNAPSHOT')

            @artifact_url = "#{ARTIFACTORY_URL}/api/storage/ext-snapshot-local/vnet/sms/infrastructure/rpm-elasticsearch/1.0.0-SNAPSHOT//rpm-elasticsearch-1.0.0-20120411.155423-1.pom"
            register_stub_request('./resource/artifact_response.txt', 
                                  'api/storage/ext-snapshot-local/vnet/sms/infrastructure/rpm-elasticsearch/1.0.0-SNAPSHOT//rpm-elasticsearch-1.0.0-20120411.155423-1.pom')
        end

        context "given a system resource URL" do
            it "should create an ArtRest::System instance" do
                instance = ArtRest::Resource.create("#{@system_url}?foo=bar", OPTIONS)
                instance.should be_an_instance_of ArtRest::System
            end
        end

        context "given a builds resource URL" do
            it "should create an ArtRest::Builds instance" do
                instance = ArtRest::Resource.create("#{@builds_url}?foo=bar", OPTIONS)
                instance.should be_an_instance_of ArtRest::Builds
            end
        end

        context "given build resource URL" do
            it "should create an ArtRest::Build instance" do
                instance = ArtRest::Resource.create("#{@build_url}?foo=bar", OPTIONS)
                instance.should be_an_instance_of ArtRest::Build
            end
        end

        context "given a buildnumber resource URL" do
            it "should create an ArtRest::Buildnumber instance" do
                instance = ArtRest::Resource.create("#{@buildnumber_url}?foo=bar", OPTIONS)
                instance.should be_an_instance_of ArtRest::Buildnumber
            end
        end

        context "given a repositories resource URL" do
            it "should create an ArtRest::Repositories instance" do
                instance = ArtRest::Resource.create("#{@repositories_url}?foo=bar", OPTIONS)
                instance.should be_an_instance_of ArtRest::Repositories
            end
        end

        context "given a repository resource URL" do
            it "should create an ArtRest::Repository instance" do
                instance = ArtRest::Resource.create("#{@repository_url}?foo=bar", OPTIONS)
                instance.should be_an_instance_of ArtRest::Repository
            end
        end

        context "given a folder resource URL" do
            it "should create an ArtRest::Folder instance" do
                instance = ArtRest::Resource.create("#{@folder_url}?foo=bar", OPTIONS)
                instance.should be_an_instance_of ArtRest::Folder
            end
        end

        context "given an artifact resource URL" do
            it "should create an ArtRest::Artifact instance" do
                instance = ArtRest::Resource.create("#{@artifact_url}?foo=bar", OPTIONS)
                instance.should be_an_instance_of ArtRest::Artifact
            end
        end
    end

    describe "#base_url" do
        it "should correctly expose the 'base_url' property" do
            resource = ArtRest::Resource.new("#{ARTIFACTORY_URL}/api/resource", OPTIONS)
            base_url = resource.base_url
            base_url.should_not be_nil
            base_url.should eq ARTIFACTORY_URL
        end
    end

    describe "#content" do
        before(:each) do
            @string_url = "#{ARTIFACTORY_URL}/api/string"
            @string_res  = StringResourceSample.new(@string_url, OPTIONS)
            register_stub_request('./resource/string_response.txt', "api/string")

            @json_url = "#{ARTIFACTORY_URL}/api/json"
            @json_res  = JsonResourceSample.new(@json_url, OPTIONS)
            register_stub_request('./resource/json_response.txt', "api/json")
        end

        context "when dealing with plain text content" do
            it "should return content as string" do
                content = @string_res.content
                content.should_not be_nil
                content.should be_an_instance_of String
            end
        end

        context "when dealing with json content" do
            it "should return content as ruby hash" do
                content = @json_res.content
                content.should_not be_nil
                content.should be_an_instance_of Hash
            end
        end

        context "when passing in a block" do
            it "should pass content on to a given block" do
                @string_res.content do |content|
                    content.should_not be_nil
                    content.should be_an_instance_of String
                end
            end
        end
    end

    describe "#[]" do
        before(:each) do
            @json_url = "#{ARTIFACTORY_URL}/api/json"
            @json_res  = JsonResourceSample.new(@json_url, OPTIONS)
            register_stub_request('./resource/sub_response.txt', "api/json/sub")
        end

        it "should return sub resource of appropriate type" do
            sub_resource = @json_res['/sub']
            sub_resource.should_not be_nil
            sub_resource.should be_an_instance_of SubResourceSample
        end
    end
end

class StringResourceSample < ArtRest::Resource

    self.mime_type = MIME::Types['text/plain']

    class << self

        protected

        def matches_path(path, options)
            path =~ /^\/api\/string$/
        end
    end
end

class JsonResourceSample < ArtRest::Resource

    class << self

        protected

        def matches_path(path, options)
            path =~ /^\/api\/json$/
        end
    end
end

class SubResourceSample < ArtRest::Resource

    self.mime_type = MIME::Types['text/plain']

    class << self

        protected

        def matches_path(path, options)
            path =~ /^\/api\/json\/sub.*/
        end
    end
end
