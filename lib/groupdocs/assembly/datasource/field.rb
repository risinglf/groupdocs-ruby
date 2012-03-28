module GroupDocs
  module Assembly
    class DataSource::Field < GroupDocs::Api::Entity

      TYPES = {
        text:   0,
        binary: 1,
      }

      # @attr [String] field
      attr_accessor :field
      # @attr [Integer] type
      attr_accessor :type
      # @attr [Array<String>] values
      attr_accessor :values

      #
      # Returns field type in human-readable format.
      #
      # @return [Symbol]
      #
      def type
        TYPES.invert[@type]
      end

    end # DataSource::Field
  end # Assembly
end # GroupDocs
