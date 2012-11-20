module GroupDocs
  class Questionnaire::Execution < Api::Entity

    include Api::Helpers::Status

    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [Integer] questionnaire_id
    attr_accessor :questionnaire_id
    # @attr [String] questionnaire_name
    attr_accessor :questionnaire_name
    # @attr [GroupDocs::User] owner
    attr_accessor :owner
    # @attr [GroupDocs::User] executive
    attr_accessor :executive
    # @attr [GroupDocs::User] approver
    attr_accessor :approver
    # @attr [Integer] datasource_id
    attr_accessor :datasource_id
    # @attr [Symbol] status
    attr_accessor :status

    #
    # Converts status to human-readable format.
    #
    # @return [Symbol]
    #
    def status
      parse_status(@status)
    end

    %w(owner executive approver).each do |method|
      #
      # Converts hash of user options to GroupDocs::User object.
      #
      # @param [GroupDocs::User, Hash] options
      #
      define_method(:"#{method}=") do |options|
        case options
        when User then instance_variable_set(:"@#{method}", options)
        when Hash then instance_variable_set(:"@#{method}", User.new(options))
        end
      end
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
