require File.expand_path("../../spec_helper", __FILE__)

describe ArtRest::Resources do

    before(:each) do
        @resources_path = "api/builds";
        @resources_url = "#{ARTIFACTORY_URL}/#{@resources_path}"
        @resources_res  = ResourcesSample.new(@resources_url, OPTIONS)
        register_stub_request('./resources/resources_response.txt', @resources_path)
    end

    it "should return json content as Ruby hash" do
        content = @resources_res.content
        content.should_not be_nil
        content.should be_an_instance_of Hash
    end

    it "should iterate over all included resources" do
        @resources_res.each do |res|
            res.should_not be_nil
            res.should be_an_instance_of ResourcesSample::Resource
        end
    end
end

class ResourcesSample < ArtRest::Resources

    class Resource < ArtRest::Resource

        class << self

            protected

            def matches_path(path, options)
                path =~ %r|^/artifactory/api/builds/\w+$|
            end
        end

        def initialize(resource_url, options, &block)
            super(resource_url, options, &block)
        end
    end

    self.mime_type = MIME::Types['application/json']
    self.resources_creator = Proc.new do |content, options|
        self_url = content['uri']
        content['builds'].map { |build| ResourcesSample::Resource.new("#{self_url}#{build['uri']}", OPTIONS) }
    end

    class << self

        protected

        def matches_path(path, options)
            path =~ %r|^/artifactory/api/builds$|
        end
    end

    def initialize(url, options, &block)
        super(url, options, &block)
    end
end
