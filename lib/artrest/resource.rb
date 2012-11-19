
module ArtRest

    class Resource < RestClient::Resource

        class_attribute :mime_type, :instance_writer => false

        self.mime_type = MIME::Types['application/json']

        @@subclasses = []

        class << self

            public

            def inherited subclass
                @@subclasses << subclass
            end

            protected

            def create url, options, &block
                @@subclasses.each do |subclass|
                    return subclass.new url, options, &block if subclass.matches_path URI.split(url)[5]
                end
                raise ArgumentError.new "Unsupported resource URL #{url}"
            end

            def matches_path path
                raise NotImplementedError.new "matches_path is an abstract class method that should not be called on the superclass"
            end
        end

        @content   = nil

        public

        def initialize url, options, &block
            check_options options
            super url, options, &block
        end

        def content
            return _content unless block_given?
            yield _content
        end

        def [](suburl, &new_block)
            case
            when block_given? then ArtRest::Resource.create concat_urls(url, suburl), options, &new_block
            when block        then ArtRest::Resource.create concat_urls(url, suburl), options, &block
            else
                ArtRest::Resource.create concat_urls(url, suburl), options
            end
        end

        private

        def _content
            return @content if @content
            raw = get
            @content = case mime_type
                       when MIME::Types['application/json'] then JSON.parse raw
                       else raw
                       end
            @content
        end

        def check_options options
            raise ArgumentError, "Must pass :user" unless options[:user]
            raise ArgumentError, "Must pass :password" unless options[:password]
        end
    end
end
