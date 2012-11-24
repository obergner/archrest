
module ArtRest

    class Resource < RestClient::Resource

        # Hide method from RestClient::Resource by default since they
        # may make no sense on a concrete subclass.
        private :get, :post, :put, :delete, :head, :patch

        # This class' mime type, stored using active support's
        # class_attribute
        class_attribute :mime_type, :instance_writer => false
        self.mime_type = MIME::Types['application/json']

        # Take an array of symbols [*attrs] and for each symbol
        # [attr] define an instance method "attr" on this class 
        # that returns "content["attr"].
        # So, given an attribute ":modifiedBy" this will define
        #    def modifiedBy
        #        content['modifiedBy']
        #    end
        def self.resource_attributes(*attrs)
            attrs.each do |attr|
                define_method(attr) do
                    return content[attr.to_s] unless block_given?
                    yield content[attr.to_s]
                end
            end
        end

        # Array of all RestClient::Resource subclasses
        @@subclasses = []

        class << self

            public

            def inherited(subclass)
                @@subclasses << subclass
            end

            def create(resource_url, options, &block)
                check_options(options)
                @@subclasses.each do |subclass|
                    return subclass.new(resource_url, options, &block) if
                    subclass.respond_to?(:matches_path) and
                        subclass.matches_path(relative_path(resource_url, options), options)
                end
                raise ArgumentError.new("Unsupported resource URL #{resource_url}")
            end

            def check_options(options)
                raise ArgumentError, "Must pass :base_url" unless options[:base_url]
                raise ArgumentError, "Must pass :user" unless options[:user]
                raise ArgumentError, "Must pass :password" unless options[:password]
            end

            protected

            def relative_path(resource_url, options)
                check_options(options)
                base_path     = Addressable::URI.parse(options[:base_url]).path
                resource_path = Addressable::URI.parse(resource_url).path
                resource_path.slice!(base_path)
                resource_path
            end
        end

        @content   = nil

        public

        def initialize(resource_url, options, content = nil, &block)
            self.class.check_options(options)
            super(resource_url, options, &block)
            @content = content if content
        end

        def base_url
            options[:base_url]
        end

        def content
            return _content unless block_given?
            yield _content
        end

        def [](suburl, &new_block)
            case
            when block_given? then ArtRest::Resource.create(concat_urls(url, suburl), options, &new_block)
            when block        then ArtRest::Resource.create(concat_urls(url, suburl), options, &block)
            else
                ArtRest::Resource.create(concat_urls(url, suburl), options)
            end
        end

        private

        def _content
            return @content if @content
            raw = get
            @content = case self.mime_type
                       when MIME::Types['application/json'] then JSON.parse(raw)
                       else raw
                       end
            @content
        end
    end
end
