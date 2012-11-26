
module ArtRest

    # Abstract base class for all Artifactory resources.
    #
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
            #   - +options+      -> Options hash holding base_url, user and
            #     password [required]
            #   - +block+        -> Passed on to <tt>RestClient::Resource.initialize</tt> [optional]
            # * *Returns* :
            #   - An instance of a concrete ArtRest::Resource subclass appropriate
            #     for the supplied +resource_url+
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

            def check_options(options) # :nodoc:
                raise ArgumentError, "Must pass :base_url" unless options[:base_url]
                raise ArgumentError, "Must pass :user" unless options[:user]
                raise ArgumentError, "Must pass :password" unless options[:password]
            end

            protected

            def relative_path(resource_url, options) # :nodoc:
                check_options(options)
                base_path     = Addressable::URI.parse(options[:base_url]).path
                resource_path = Addressable::URI.parse(resource_url).path
                resource_path.slice!(base_path)
                resource_path
            end
        end

        # Hide method from RestClient::Resource by default since they
        # may make no sense on a concrete subclass.
        protected :get, :post, :put, :delete, :head, :patch

        # This class' mime type
        self.mime_type = MIME::Types['application/json']

        public

        # Create a new ArtRest::Resource instance, representing the Artifactory
        # resource located at +resource_url+. Use username and password
        # contained in +options+ to authenticate against the Artifactory server.
        # Optionally take and cache the parsed +content+ of the resource pointed
        # to by +resource_url+ in case the caller has already accessed that
        # resource. A +block+, if given, will transparently be passed on to
        # RestClient::Resource's - our ancestor's - constructor.
        #
        # * *Args*    :
        #   - +resource_url+ -> URL of the Artifactory resource
        #   - +options+ -> A hash containing our Artifactory server's base url,
        #     and a username and a password to authenticate against that server
        #   - +content+ -> The *parsed* content of the resource, if the caller
        #     has already accessed that resource [optional]
        #   - +block+ -> A block that will be passed on to
        #     RestClient::Resource#initialize [optional]
        #
        def initialize(resource_url, options, content = nil, &block)
            self.class.check_options(options)
            super(resource_url, options, &block)
            @content = content if content
        end

        # Return our Artifactory server's <em>base url</em>.
        #
        # === Example
        #
        #    http://localhost:8081/artifactory
        #
        def base_url 
            options[:base_url]
        end

        # Return this resource's *parsed* content. In almost all cases this will
        # be a Hash representing this resource's JSON content. The only
        # exception is ArtRest::System, where the content is a plain text
        # representation and thus returned as a String.
        #
        # If called with a +block+, yield this resource's parsed content to that
        # block.
        #
        # * *Args*    :
        #   - +block+ -> A block to yield this resource's parsed content to [optional]
        # * *Returns* :
        #   - If called *without* a block, this resource's *parsed* content, most
        #     often a +Hash+, otherwise a +String+.
        #     If called *with* a block, +self+
        #
        def content # :yields: content
            return _content unless block_given?
            # If our block returns a value, this will become this resource's new
            # content
            yield _content
            self
        end

        # Yield this resource's parsed content to +block+. If block returns a value,
        # accept this value as this resource's new content. Calling this method
        # is therefore a potentially destructive operation.
        #
        # Also see #content.
        #
        # * *Args*    :
        #   - +block+ -> A block to yield this resource's parsed content to
        # * *Returns* :
        #   - +self+
        #
        def content! &block # :yields: content
            # If our block returns a value, this will become this resource's new
            # content
            new_content = yield _content
            @content = new_content if new_content
            self
        end

        # Look up and return the ArtRest::Resource instance that is located at
        # +relative_path+ relative to this resource. Take care to return the
        # appropriate ArtRest::Resource subtype.
        #
        # === Example
        #
        # Given
        #   
        #   repository = ArtRest::Repository.new('http://localhost:8081/artifactory/api/storage/libs-release-local', { ... })
        #
        # the expression
        #
        #   folder = repository['/commons-lang/commons-lang/3.2.0']
        #
        # will return an ArtRest::Folder instance.
        #
        # * *Args*    :
        #   - +relative_path+ -> The path of the resource to look up, relative to
        #     this resource
        #   - +block+ -> A block that will be transparently passed on to RestClient::Resource#initialize [optional]
        # * *Returns* :
        #   - An ArtRest::Resource instance of appropriate type representing the
        #     Artifactory resource located at +relative_path+ relative to this resource
        #
        def [](relative_path, &new_block)
            case
            when block_given? then ArtRest::Resource.create(concat_urls(url, relative_path), options, &new_block)
            when block        then ArtRest::Resource.create(concat_urls(url, relative_path), options, &block)
            else
                ArtRest::Resource.create(concat_urls(url, relative_path), options)
            end
        end

        private

        def _content # :nodoc:
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
