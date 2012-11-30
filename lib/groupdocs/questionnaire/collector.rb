module GroupDocs
  class Questionnaire::Collector < Api::Entity

    include Api::Helpers::Status

    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [Integer] questionnaire_id
    attr_accessor :questionnaire_id
    # @attr [Symbol] status
    attr_accessor :status
    # @attr [Symbol] type
    attr_accessor :type
    # @attr [Integer] resolved_executions
    attr_accessor :resolved_executions
    # @attr [Array<String>] emails
    attr_accessor :emails
    # @attr [Time] modified
    attr_accessor :modified

    #
    # Converts status to human-readable format.
    # @return [Symbol]
    #
    def status
      parse_status(@status)
    end

    #
    # Converts type to human-readable format.
    # @return [Symbol]
    #
    def type
      parse_status(@type)
    end

    #
    # Converts timestamp which is return by API server to Time object.
    # @return [Time]
    #
    def modified
      Time.at(@modified / 1000)
    end

  end # Questionnaire::Collector
end # GroupDocs
