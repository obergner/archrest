
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

            # Define a singleton method +mime_type+ on the class this
            # method is called on, where calling +mime_type+ will return
            # +value+.
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
            #   [+resource_url+] URL of the resource to create [required]
            #   [+options+]      Options hash holding base_url, user and
            #                    password [required]
            #   [+block+]        Passed on to <tt>RestClient::Resource.initialize</tt> [optional]
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
        #   [+block+] A block to yield this resource's parsed content to [optional]
        # * *Returns* :
        #   - If called *without* a block, this resource's *parsed* content, most
        #     often a +Hash+, otherwise a +String+.
        #     If called *with* a block, +self+
        # * *Raises*  :
        #   [+RestClient::ResourceNotFound+]  If the resource this instance
        #                                     represents does in fact not exist
        #                                     on the server
        #   [+RestClient::Unauthorized+]      If accessing this resource is not
        #                                     authorized
        #
        def content # :yields: content
            return _content unless block_given?
            # If our block returns a value, this will become this resource's new
            # content
            yield _content
            self
        end

        # Return this resource's *unparsed* content as a string[rdoc-ref:String].
        #
        # Most of Artifactory's resources are represented in JSON, and these
        # will be parsed into an equivalent ruby {hash}[rdoc-ref:Hash] upon load. This
        # method will *unparse* that hash back into a JSON string.
        #
        # In all other cases, when a resource's mime type is *not*
        # 'application/json', that resource's representation will remain
        # unchanged, i.e. will be stored as a string, and this method will
        # return that string as is.
        #
        # * *Returns* :
        #   - This resource's unparsed content, a {string}[rdoc-ref:String]
        # * *Raises*  :
        #   [+RestClient::ResourceNotFound+]  If the resource this instance
        #                                     represents does in fact not exist
        #                                     on the server
        #   [+RestClient::Unauthorized+]      If accessing this resource is not
        #                                     authorized
        #
        def unparsed_content(fmt = :plain)
            return _content unless self.class.mime_type == MIME::Types['application/json']
            case fmt
            when :pretty then
                JSON.pretty_generate(_content)
            else
                JSON.generate(_content)
            end
        end

        # Set this resource's representation to +value+. Handle +value+ as
        # appropriate for this resource's mime type:
        #
        # === application/json
        #
        # If we are dealing with a JSON resource - the most common case -
        # +value+ may be one of
        #
        # * Hash:   will be accepted as is
        # * String: will be interpreted as a JSON encoded string and parsed into a
        #   ruby Hash
        #
        # Raise an +ArgumentError+ in all other cases.
        #
        # === text/plain or application/xml
        #
        # In this case, +value+ may be of any kind, but will be converted into a
        # String via calling +value+.#to_s.
        #
        # * *Args*    :
        #   - +value+ -> This resource's new content/representation. See above.
        # * *Raises* :
        #   - +ArgumentError+ -> If this resource's mime type is
        #     +application/json+ and value is neither a Hash nor a String
        #
        def content=(value)
            if value.nil?
                @content = nil
                return
            end
            case self.class.mime_type
            when MIME::Types['application/json'] then
                if value.is_a? Hash
                    @content = value
                elsif value.is_a? String
                    @content = JSON.parse(value)
                else
                    raise ArgumentError, "Can only accept Hash and String. Got: #{value.class}"
                end
            else
                @content = value.to_s
            end
        end

        # Yield this resource's parsed content to +block+. If block returns a value,
        # accept this value as this resource's new content. Calling this method
        # is therefore a potentially destructive operation.
        #
        # Also see #content.
        #
        # * *Args*    :
        #   [+block+]  A block to yield this resource's parsed content to
        # * *Returns* :
        #   - +self+ This instance
        # * *Raises*  :
        #   [+RestClient::ResourceNotFound+]  If the resource this instance
        #                                     represents does in fact not exist
        #                                     on the server
        #   [+RestClient::Unauthorized+]      If accessing this resource is not
        #                                     authorized
        #
        def content! &block # :yields: content
            # If our block returns a value, this will become this resource's new
            # content
            new_content = yield _content
            self.content = new_content if new_content
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
        #   [+relative_path+] The path of the resource to look up, relative to
        #                     this resource
        #   [+block+]         A block that will be transparently passed on to 
        #                     RestClient::Resource#initialize [optional]
        # * *Returns* :
        #   - An ArtRest::Resource instance of appropriate type representing the
        #     Artifactory resource located at +relative_path+ relative to this resource
        #
        def [](relative_path, &new_block)
            case
            when block_given? then 
                ArtRest::Resource.create(concat_urls(url, relative_path), options, &new_block)
            when block        then 
                ArtRest::Resource.create(concat_urls(url, relative_path), options, &block)
            else
                ArtRest::Resource.create(concat_urls(url, relative_path), options)
            end
        end

        # Hide method from RestClient::Resource by default since they
        # may make no sense on a concrete subclass.
        protected :get, :post, :put, :delete, :head, :patch

        protected

        # Post changes made to this resource's content/representation since
        # loading it from Artifactory - if any - back to the server, i.e.
        # *update* the resource this instance represents.
        #
        # === Example
        #
        #  sysConfig = ArtRest::System::GeneralConfiguration.get
        #  sysConfig.content = ...
        #  sysConfig.update!
        #
        # * *Args*    :
        #   - +additional_headers+ -> Any additional headers to be set on the
        #     POST request
        #
        def update!(additional_headers = {}, &block)
            post(self.unparsed_content, additional_headers, &block)
        end

        # Take +content+ and make it this resource's new #content by calling
        # #content= +content+. Subsequently, post this resource's changes back to
        # Artifactory, i.e. *update* the resource this instance represents.
        #
        # Calling this method on a resource +res+ is therefore equivalent to
        #
        #  res.content = content
        #  res.update!(additional_headers, &block)
        #
        # * *Args*    :
        #  [+content+]            This resource's new #content
        #  [+additional_headers+] Any additional headers to be set on this POST
        #                         request that calling this method entails
        #  [+block+]              A block that will be passed on to
        #                         RestClient::Resource#post, i.e. it will handle
        #                         the response to our POST request
        #
        def update_with!(content, additional_headers = {}, &block)
            self.content = content
            update!(additional_headers, &block)
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
