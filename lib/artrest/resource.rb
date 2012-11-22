
module ArtRest

    class Resource < RestClient::Resource

        class_attribute :mime_type, :instance_writer => false
        self.mime_type = MIME::Types['application/json']

        @@subclasses = []

        class << self

            public

            def inherited(subclass)
                @@subclasses << subclass
            end

            def create(resource_url, options, &block)
                check_options(options)
                @@subclasses.each do |subclass|
                    return subclass.new(resource_url, options, &block) if subclass.matches_path(relative_path(resource_url, options), options)
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

            def matches_path(path, options)
                raise NotImplementedError.new("matches_path is an abstract class method that should not be called on the superclass")
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
