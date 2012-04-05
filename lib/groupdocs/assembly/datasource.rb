module GroupDocs
  module Assembly
    class DataSource < GroupDocs::Api::Entity

      require 'groupdocs/assembly/datasource/field'

      #
      # Returns datasource with given ID.
      #
      # @param [Integer] id
      # @param [Hash] options
      # @option options [Array] :field Array of field names to be returned. All by default
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Assembly::DataSource, nil]
      #
      def self.get!(id, options = {}, access = {})
        api = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/merge/{{client_id}}/datasources/#{id}"
        end
        api.add_params(options)
        json = api.execute!

        GroupDocs::Assembly::DataSource.new(json[:datasource])
      rescue GroupDocs::Errors::BadResponseError
        nil
      end

      # @attr [Integer] id
      attr_accessor :id
      # @attr [String] descr
      attr_accessor :descr
      # @attr [Integer] questionnaire_id
      attr_accessor :questionnaire_id
      # @attr [Time] created_on
      attr_accessor :created_on
      # @attr [Time] modified_on
      attr_accessor :modified_on
      # @attr [Array<GroupDocs::Assembly::DataSource::Field>] fields
      attr_accessor :fields

      # Human-readable accessors
      alias_method :description,  :descr
      alias_method :description=, :descr=

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
      # Converts each field to GroupDocs::Assembly::DataSource::Field object.
      #
      # @param [Array<GroupDocs::Assembly::DataSource::Field, Hash>] fields
      #
      def fields=(fields)
        if fields
          @fields = fields.map do |field|
            if field.is_a?(GroupDocs::Assembly::DataSource::Field)
              field
            else
              GroupDocs::Assembly::DataSource::Field.new(field)
            end
          end
        end
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

      #
      # Adds datasource.
      #
      # @example
      #   field = GroupDocs::Assembly::DataSource::Field.new(field: 'test', values: %w(test test))
      #   datasource = GroupDocs::Assembly::DataSource.new
      #   datasource.add_field(field)
      #   datasource.add!
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def add!(access = {})
        json = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = '/merge/{{client_id}}/datasources'
          request[:request_body] = to_hash
        end.execute!

        self.id = json[:datasource_id]
      end

      #
      # Updates datasource.
      #
      # @example
      #   field = GroupDocs::Assembly::DataSource::Field.new(field: 'test', values: %w(test test))
      #   datasource = GroupDocs::Assembly::DataSource.get!(180)
      #   datasource.add_field(field)
      #   datasource.update!
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def update!(access = {})
        GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/merge/{{client_id}}/datasources/#{id}"
          request[:request_body] = to_hash
        end.execute!
      end

      #
      # Removes datasource.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def remove!(access = {})
        GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/merge/{{client_id}}/datasources/#{id}"
        end.execute!
      # TODO: fix this in API
      rescue RestClient::BadRequest
        nil
      end

    end # DataSource
  end # Assembly
end # GroupDocs
