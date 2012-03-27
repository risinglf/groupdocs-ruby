module GroupDocs
  module Assembly
    class Questionnaire::Execution < GroupDocs::Api::Entity

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

    end # Questionnaire::Execution
  end # Assembly
end # GroupDocs
