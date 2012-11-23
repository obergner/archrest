
module ArtRest

    class Resources < ArtRest::Resource
        include Enumerable

        class_attribute :resources_creator, :instance_writer => false
        self.resources_creator = Proc.new do |content, options|
            raise NotImplementedError.new('ArtRest::Resources is an abstract base class and should never be called directly')
        end

        public

        def each &block
            resources_creator.call(content, options).each &block 
        end
    end
end
