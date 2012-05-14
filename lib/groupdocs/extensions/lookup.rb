module GroupDocs
  module Extensions
    #
    # Extends classes providing them with .find! and .find_all! class methods
    # which is a bit of sugar for working with files, folder and documents,
    #
    # It's not that flexible because requires extending class to implement
    # .all! class method.
    #
    # This module is a subject to modifications.
    #
    module Lookup

      #
      # Returns first object matching given options.
      #
      # @param [Symbol] attribute
      # @param [Integer, String, Regexp] value
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Api::Entity] Matching entity
      #
      def find!(attribute, value, access = {})
        find_all!(attribute, value, access).first
      end

      #
      # Returns all objects matching given options.
      #
      # Each entity has to implement #all! method for this to work.
      #
      # @param [Symbol] attribute
      # @param [Integer, String, Regexp] value
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array] Array of matching entities
      #
      # @raise [NoMethodError] if extending class does not implement .all! class method.
      #
      def find_all!(attribute, value, access = {})
        respond_to?(:all!) or raise NoMethodError, "#{self}.all! is not implemented - aborting."

        all!('/', access).select do |object|
          value === object.send(attribute)
        end
      end

    end # Lookup
  end # Extensions
end # GroupDocs
