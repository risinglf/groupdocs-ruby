module GroupDocs
  class Questionnaire::Execution < GroupDocs::Api::Entity

    include Api::Helpers::Status

    #
    # Returns an array of all executions.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Questionnaire::Execution>]
    #
    def self.all!(access = {})
      Questionnaire.executions!(access)
    end

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
    # Converts status to human-readable format.
    #
    # @return [Symbol]
    #
    def status
      parse_status(@status)
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
      status = parse_status(status)

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/merge/{{client_id}}/questionnaires/executions/#{id}/status"
        request[:request_body] = status
      end.execute!

      self.status = status
    end

    #
    # Updates execution on server.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def update!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/merge/{{client_id}}/questionnaires/executions/#{id}"
        request[:request_body] = to_hash
      end.execute!
    end

  end # Questionnaire::Execution
end # GroupDocs
