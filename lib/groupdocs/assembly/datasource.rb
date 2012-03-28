module GroupDocs
  module Assembly
    class DataSource < GroupDocs::Api::Entity

      require 'groupdocs/assembly/datasource/field'

      # @attr [Integer] id
      attr_accessor :id
      # @attr [Integer] questionnaire_id
      attr_accessor :questionnaire_id
      # @attr [Time] created_on
      attr_accessor :created_on
      # @attr [Time] modified_on
      attr_accessor :modified_on
      # @attr [Array<GroupDocs::Assembly::DataSource::Field>] fields
      attr_accessor :fields

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @return [Time]
      #
      def created_on
        Time.at(@created_on)
      end

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @return [Time]
      #
      def modified_on
        Time.at(@modified_on)
      end

      #
      # Adds field to datasource.
      #
      # @param [GroupDocs::Assembly::DataSource::Field] question
      # @raise [ArgumentError] if field is not GroupDocs::Assembly::DataSource::Field object
      #
      def add_field(field)
        field.is_a?(GroupDocs::Assembly::DataSource::Field) or raise ArgumentError,
          "Field should be GroupDocs::Assembly::DataSource::Field object, received: #{field.inspect}"

        @fields ||= Array.new
        @fields << field
      end

    end # DataSource
  end # Assembly
end # GroupDocs
