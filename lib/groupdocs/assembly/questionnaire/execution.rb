module GroupDocs
  module Assembly
    class Questionnaire::Execution < GroupDocs::Api::Entity

      STATUSES = {
        draft:     0,
        submitted: 1,
        executed:  2,
        approved:  3,
        rejected:  4,
        closed:    5,
      }

      # @attr [Integer] id
      attr_accessor :id
      # @attr [Integer] ownerId
      attr_accessor :ownerId
      # @attr [Integer] questionnaireId
      attr_accessor :questionnaireId
      # @attr [Integer] executiveId
      attr_accessor :executiveId
      # @attr [Integer] approverId
      attr_accessor :approverId
      # @attr [Integer] datasourceId
      attr_accessor :datasourceId
      # @attr [Integer] documentId
      attr_accessor :documentId
      # @attr [Integer] status
      attr_accessor :status
      # @attr [String] guid
      attr_accessor :guid

      # Human-readable accessors
      alias_method :owner_id,           :ownerId
      alias_method :owner_id=,          :ownerId=
      alias_method :questionnaire_id,   :questionnaireId
      alias_method :questionnaire_id=,  :questionnaireId=
      alias_method :executive_id,       :executiveId
      alias_method :executive_id=,      :executiveId=
      alias_method :approver_id,        :approverId
      alias_method :approver_id=,       :approverId=
      alias_method :datasource_id,      :datasourceId
      alias_method :datasource_id=,     :datasourceId=
      alias_method :document_id,        :documentId
      alias_method :document_id=,       :documentId=

      #
      # Updates status with machine-readable format.
      #
      # If you want to update status on server, use #set_status! method.
      #
      # @param [Symbol, Integer] status
      #
      def status=(status)
        status = STATUSES[status] if status.is_a?(Symbol)
        @status = status
      end

      #
      # Returns execution status in human-readable format.
      #
      # @return [Symbol]
      #
      def status
        STATUSES.invert[@status]
      end

      #
      # Updates status of execution on server.
      #
      # @param [Symbol] status
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def set_status!(status, access = {})
        GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/merge/{{client_id}}/questionnaires/executions/#{id}/status"
          request[:request_body] = STATUSES[status]
        end.execute!

        self.status = status
      end

    end # Questionnaire::Execution
  end # Assembly
end # GroupDocs
