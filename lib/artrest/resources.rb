
module ArtRest

    # An ArtRest::Resource that doubles as a collection of resources, each such
    # resource being an ArtRest::Resource instance. This is an abstract base
    # class that is *not* meant to be instantiated.
    #
    # === Example
    #
    # An ArtRest::Builds instance is a collection of ArtRest::Build instances.
    #
    class Resources < ArtRest::Resource
        include Enumerable

        class << self

            # An ArtRest::Resources instance is represented by a parsed
            # JSON hash. In order to be able to iterate over the contained
            # ArtRest::Resource instances we need a means of converting
            # that JSON hash into an array of ArtRest::Resource instances
            # of an appropriate subtype. We choose a +block+ taking the JSON hash
            # and the +options+ hash and returning an array of ArtRest::Resource
            # instances.
            #
            # This method assigns that block to this class.
            #
            # * *Args*    :
            #   - +block+ -> A +block+ taking a parsed JSON hash and an +options+
            #     hash and returning an array of appropriate ArtRest::Resource
            #     instances
            #
            def resources_creator=(block)
                self.singleton_class.class_eval do
                    define_method(:resources_creator) do
                        block
                    end
                end
            end
        end

        public
        
        # Iterate over all ArtRest::Resource instances contained in this
        # instance. Yield each such instance to the supplied +block+.
        #
        # * *Args*    :
        #   - +block+ -> The +block+ to yield each contained ArtRest::Resource
        #     instance to
        #
        def each &block # :yields: content, options
            self.class.resources_creator.call(content, options).each &block 
        end
    end
end
