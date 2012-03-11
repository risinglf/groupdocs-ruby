module GroupDocs
  module Api
    module Sugar
      module Lookup

        #
        # Returns first object matching given options.
        #
        # @param [Symbol] attribute
        # @param [Integer, String, Regexp] value
        # @return [GroupDocs::Api::Entity] Matching entity
        #
        def find!(attribute, value)
          find_all!(attribute, value).first
        end

        #
        # Returns all objects matching given options.
        #
        # Each entity has to implement #all! method for this to work.
        #
        # @param [Symbol] attribute
        # @param [Integer, String, Regexp] value
        # @return [Array] Array of matching entities
        #
        # @raise [NoMethodError] if extending class does not implement #all! class method.
        #
        def find_all!(attribute, value)
          respond_to?(:all!) or raise NoMethodError, "#{self}#all! is not implemented - aborting."

          all!.select do |object|
            case value
            when Regexp then object.send(attribute) =~ value
            else object.send(attribute) == value
            end
          end
        end

      end # Lookup
    end # Sugar
  end # Api
end # GroupDocs
