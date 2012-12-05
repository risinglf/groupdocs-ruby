module GroupDocs
  class Questionnaire::Collector < Api::Entity

    include Api::Helpers::Status

    #
    # Returns collector by its guid.
    #
    # @param [String] guid
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Questionnaire::Collector]
    #
    def self.get!(guid, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/collectors/#{guid}"
      end.execute!

      collector = json[:collector]
      collector.merge!(questionnaire: Questionnaire.new(id: collector[:questionnaire_id]))

      new(collector)
    end

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
    #   questionnaire = GroupDocs::Questionnaire.get!(1)
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
        request[:path] = "/merge/{{client_id}}/questionnaires/#{questionnaire.guid}/collectors"
        request[:request_body] = to_hash
      end.execute!

      self.id   = json[:collector_id]
      self.guid = json[:collector_guid]
    end

    #
    # Updates collector.
    #
    # @example
    #   questionnaire = GroupDocs::Questionnaire.get!(1)
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

    #
    # Removes collector.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def remove!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/merge/{{client_id}}/questionnaires/collectors/#{guid}"
      end.execute!
    end

    #
    # Returns an array of questionnaire collector executions.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Questionnaire::Execution>]
    #
    def executions!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/collectors/#{guid}/executions"
      end.execute!

      json[:executions].map do |execution|
        Questionnaire::Execution.new(execution)
      end
    end

    #
    # Adds new questionnaire execution.
    #
    # @example
    #   questionnaire = GroupDocs::Questionnaire.get!(1)
    #   collector = questionnaire.collectors!.first
    #   execution = GroupDocs::Questionnaire::Execution.new
    #   execution.executive = GroupDocs::User.new(primary_email: 'john@smith.com')
    #   # make sure to save execution as it has updated attributes
    #   execution = collector.add_execution!(execution)
    #   #=> #<GroupDocs::Questionnaire::Execution @id=1, @questionnaire_id=1>
    #
    # @param [GroupDocs::Questionnaire::Execution] execution
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Questionnaire::Execution] updated execution
    #
    def add_execution!(execution, access = {})
      execution.is_a?(GroupDocs::Questionnaire::Execution) or raise ArgumentError,
        "Execution should be GroupDocs::Questionnaire::Execution object, received: #{execution.inspect}"

      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/merge/{{client_id}}/questionnaires/collectors/#{guid}/executions"
        request[:request_body] = execution.to_hash
      end.execute!

      execution.id = json[:execution_id]
      execution.guid = json[:execution_guid]
      execution.collector_id = json[:collector_id]

      execution
    end

  end # Questionnaire::Collector
end # GroupDocs
