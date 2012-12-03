module GroupDocs
  class Questionnaire::Collector < Api::Entity

    include Api::Helpers::Status

    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [GroupDocs::Questionnaire] questionnaire
    attr_accessor :questionnaire
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
    # Creates new GroupDocs::Questionnaire::Collector.
    #
    # @raise [ArgumentError] If questionnaire is not passed or is not an instance of GroupDocs::Questionnaire
    #
    def initialize(options = {}, &blk)
      super(options, &blk)
      questionnaire.is_a?(GroupDocs::Questionnaire) or raise ArgumentError,
        "You have to pass GroupDocs::Questionnaire object: #{questionnaire.inspect}."
    end

    #
    # Converts status to human-readable format.
    # @return [Symbol]
    #
    def status
      parse_status(@status)
    end

    #
    # Updates type with machine-readable format.
    #
    # @param [Symbol] type
    #
    def type=(type)
      @type = type.is_a?(Symbol) ? type.to_s.capitalize : type
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

    #
    # Adds collector.
    #
    # @example
    #   questionnaire = GroupDocs::Questionnaire.get!('110e8e64a0fe8da246b7e7879e51943f')
    #   collector = GroupDocs::Questionnaire::Collector.new(questionnaire: questionnaire)
    #   collector.type = :link
    #   collector.add!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def add!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/merge/{{client_id}}/questionnaires/#{get_questionnaire_id}/collectors"
        request[:request_body] = to_hash
      end.execute!

      self.id   = json[:collector_id]
      self.guid = json[:collector_guid]
    end

    #
    # Updates collector.
    #
    # @example
    #   questionnaire = GroupDocs::Questionnaire.get!('110e8e64a0fe8da246b7e7879e51943f')
    #   collector = questionnaire.collectors!.first
    #   collector.type = :embedded
    #   collector.update!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def update!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/merge/{{client_id}}/questionnaires/collectors/#{guid}"
        request[:request_body] = to_hash
      end.execute!
    end

    private

    #
    # Returns questionnaire identifier.
    #
    # @return [String]
    #
    def get_questionnaire_id
      questionnaire_id || questionnaire.guid
    end

  end # Questionnaire::Collector
end # GroupDocs
