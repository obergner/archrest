
module ArtRest

    class Resources < ArtRest::Resource
        include Enumerable

        class_attribute :resources_creator, :instance_writer => false
        self.resources_creator = Proc.new do |content, options|
            raise NotImplementedError.new('ArtRest::Resources is an abstract base class and should never be called directly')
        end

        class << self

            protected

            def matches_path(path, options)
                # We never match, since we are an abstract base class
                false
            end
        end

        public

        def each &block
            resources_creator.call(content, options).each &block 
        end
    end
end