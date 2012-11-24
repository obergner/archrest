
module ArtRest

    class Resource < RestClient::Resource

        class << self

            public

            # Add +subclass+ to the list of known subclasses.
            #
            # * *Args*    :
            #   - +subclass+ -> The subclass to add
            #
            def inherited(subclass)
                @@subclasses ||= []
                @@subclasses << subclass
            end

            # When called with +value+ as argument define a
            # singleton method +mime_type+ on the class this
            # method is called on, where calling +mime_type+
            # will return +value+.
            #
            # This essentially emulates a "proper" class variable
            # +mime_type+.
            #
            # * *Args*    :
            #   - +value+ -> This class' mime type [MIME::Type/required]
            #
            def mime_type=(value)
                self.singleton_class.class_eval do
                    define_method(:mime_type) do
                        value
                    end
                end
            end

            # Take an array of symbols +attrs+ and for each symbol
            # "attr" define an instance method +attr+ on this class 
            # that returns <tt>content["attr"]</tt>.
            #
            # So, given an attribute <tt>:modifiedBy</tt> this will define
            #
            #    def modifiedBy
            #        content['modifiedBy']
            #    end
            #
            def resource_attributes(*attrs)
                attrs.each do |attr|
                    define_method(attr) do
                        return content[attr.to_s] unless block_given?
                        yield content[attr.to_s]
                    end
                end
            end

            # Factory method: create and return an instance of a concrete
            # ArtRest::Resource subclass appropriate for the supplied
            # +resource_url+.
            #
            # === Example
            #
            #   ArtRest::Resource.create('http://localhost:8081/artifactory/api/system,
            #                             options)
            #
            # will return an ArtRest::System instance.
            #
            # * *Args*    :
            #   - +resource_url+ -> URL of the resource to create [required]
            #   - +options+      -> Options hash holding base_url, user and password [required]
            #   - +block+        -> Passed on to <tt>RestClient::Resource.initialize</tt> [optional]
            # * *Returns* :
            #   - An instance of a concrete ArtRest::Resource subclass appropriate
            #     supplied +resource_url+
            #
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

        # Hide method from RestClient::Resource by default since they
        # may make no sense on a concrete subclass.
        private :get, :post, :put, :delete, :head, :patch

        # This class' mime type
        self.mime_type = MIME::Types['application/json']

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
            @content = case self.class.mime_type
                       when MIME::Types['application/json'] then JSON.parse(raw)
                       else raw
                       end
            @content
        end
    end
end
