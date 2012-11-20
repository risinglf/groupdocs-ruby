module GroupDocs
  class Questionnaire < Api::Entity

    require 'groupdocs/questionnaire/execution'
    require 'groupdocs/questionnaire/page'
    require 'groupdocs/questionnaire/question'

    include Api::Helpers::Status

    #
    # Returns an array of all questionnaires.
    #
    # @param [Hash] options Hash of options
    # @option options [Symbol] :status Filter questionnaires by status
    # @option options [Integer] :page_number Page to start with
    # @option options [Integer] :page_size How many items to list
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Questionnaire>]
    #
    def self.all!(options = {}, access = {})
      options[:status] = parse_status(options[:status]) if options[:status]

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/merge/{{client_id}}/questionnaires'
      end
      api.add_params(options)
      json = api.execute!

      json[:questionnaires].map do |questionnaire|
        Questionnaire.new(questionnaire)
      end
    end

    #
    # Returns questionnaire by identifier.
    #
    # @param [Integer] id
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Questionnaire, nil]
    #
    def self.get!(id, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/#{id}"
      end.execute!

      Questionnaire.new(json[:questionnaire])
    rescue RestClient::ResourceNotFound
      nil
    end

    #
    # Returns an array of all executions.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Questionnaire::Execution>]
    #
    def self.executions!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/merge/{{client_id}}/questionnaires/executions'
      end.execute!

      json[:executions].map do |execution|
        Questionnaire::Execution.new(execution)
      end
    end

    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [String] name
    attr_accessor :name
    # @attr [Symbol] status
    attr_accessor :status
    # @attr [String] descr
    attr_accessor :descr
    # @attr [Array<GroupDocs::Questionnaire::Page>] pages
    attr_accessor :pages
    # @attr [Integer] resolved_executions
    attr_accessor :resolved_executions
    # @attr [Integer] assigned_questions
    attr_accessor :assigned_questions
    # @attr [Integer] total_questions
    attr_accessor :total_questions
    # @attr [Integer] modified
    attr_accessor :modified
    # @attr [Integer] expires
    attr_accessor :expires
    # @attr [Array<String>] document_ids
    attr_accessor :document_ids

    # Human-readable accessors
    alias_method :description,  :descr
    alias_method :description=, :descr=

    #
    # Converts each page to GroupDocs::Questionnaire::Page object.
    #
    # @param [Array<GroupDocs::Questionnaire::Page, Hash>] pages
    #
    def pages=(pages)
      if pages
        @pages = pages.map do |page|
          if page.is_a?(GroupDocs::Questionnaire::Page)
            page
          else
            Questionnaire::Page.new(page)
          end
        end
      end
    end

    #
    # Converts status to human-readable format.
    #
    # @return [Symbol]
    #
    def status
      parse_status(@status)
    end

    #
    # Adds page to questionnaire.
    #
    # @param [GroupDocs::Questionnaire::Page] page
    # @raise [ArgumentError] if page is not GroupDocs::Questionnaire::Page object
    #
    def add_page(page)
      page.is_a?(GroupDocs::Questionnaire::Page) or raise ArgumentError,
        "Page should be GroupDocs::Questionnaire::Page object, received: #{page.inspect}"

      @pages ||= Array.new
      @pages << page
    end

    #
    # Creates questionnaire.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/merge/{{client_id}}/questionnaires'
        request[:request_body] = to_hash
      end.execute!

      self.id = json[:questionnaire_id]
    end

    #
    # Updates questionnaire.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def update!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/merge/{{client_id}}/questionnaires/#{id}"
        request[:request_body] = to_hash
      end.execute!
    end

    #
    # Removes questionnaire.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def remove!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/merge/{{client_id}}/questionnaires/#{id}"
      end.execute!
    # TODO: fix this in API - http://scotland.groupdocs.com/jira/browse/CORE-391
    rescue RestClient::BadRequest
      nil
    end

    #
    # Returns array of datasources for questionnaire.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::DataSource>]
    #
    def datasources!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/questionnaires/#{id}/datasources"
      end.execute!

      json[:datasources].map do |datasource|
        DataSource.new(datasource)
      end
    end

    #
    # Creates new questionnaire execution.
    #
    # @example
    #   execution = GroupDocs::Questionnaire::Execution.new
    #   questionnaire = GroupDocs::Questionnaire.get!(1)
    #   execution = questionnaire.create_execution!(execution, 'user@email.com')
    #   #=> #<GroupDocs::Questionnaire::Execution @id=1, @questionnaire_id=1>
    #
    # @param [GroupDocs::Questionnaire::Execution] execution
    # @param [String] email
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Questionnaire::Execution] updated execution
    #
    def create_execution!(execution, email, access = {})
      execution.is_a?(GroupDocs::Questionnaire::Execution) or raise ArgumentError,
        "Execution should be GroupDocs::Questionnaire::Execution object, received: #{execution.inspect}"

      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/merge/{{client_id}}/questionnaires/#{id}/executions"
        request[:request_body] = execution.to_hash.merge(executive: { primary_email: email })
      end.execute!

      execution.id = json[:execution_id]
      execution.questionnaire_id = json[:questionnaire_id]

      execution
    end

  end # Questionnaire
end # GroupDocs
