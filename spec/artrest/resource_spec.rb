require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Resource do

    before(:each) do
        @string_url = "#{ARTIFACTORY_URL}/api/string"
        @string_res  = StringResourceSample.new @string_url, { :user => ARTIFACTORY_USER, :password => ARTIFACTORY_PWD }
        register_stub_request('./resource/string_response.txt', "api/string")

        @json_url = "#{ARTIFACTORY_URL}/api/json"
        @json_res  = JsonResourceSample.new @json_url, { :user => ARTIFACTORY_USER, :password => ARTIFACTORY_PWD }
        register_stub_request('./resource/json_response.txt', "api/json")

        register_stub_request('./resource/sub_response.txt', "api/json/sub")
    end

    it "should create an appropriate subclass instance given an URL" do
        ArtRest::Resource.public_class_method :create
        instance = ArtRest::Resource.create "#{@string_url}?foo=bar", { :user => 'admin', :password => 'password' }
        instance.should_not be_nil
        instance.should be_an_instance_of StringResourceSample
    end

    it "should return plain text content as string" do
        content = @string_res.content
        content.should_not be_nil
        content.should be_an_instance_of String
    end

    it "should pass content on to a given block" do
        @string_res.content do |content|
            content.should_not be_nil
            content.should be_an_instance_of String
        end
    end

    it "should return json content as Ruby hash" do
        content = @json_res.content
        content.should_not be_nil
        content.should be_an_instance_of Hash
    end

    it "should return sub resource of appropriate type" do
        sub_resource = @json_res['/sub']
        sub_resource.should_not be_nil
        sub_resource.should be_an_instance_of SubResourceSample
    end
end

class StringResourceSample < ArtRest::Resource

    self.mime_type = MIME::Types['text/plain']

    class << self

        protected

        def matches_path path
            path =~ /^\/artifactory\/api\/string$/
        end
    end

    def initialize url, options, &block
        super url, options, &block
    end
end

class JsonResourceSample < ArtRest::Resource

    class << self

        protected

        def matches_path path
            path =~ /^\/artifactory\/api\/json$/
        end
    end

    def initialize url, options, &block
        super url, options, &block
    end
end

class SubResourceSample < ArtRest::Resource

    self.mime_type = MIME::Types['text/plain']

    class << self

        protected

        def matches_path path
            path =~ /^\/artifactory\/api\/json\/sub.*/
        end
    end

    def initialize url, options, &block
        super url, options, &block
    end
end
