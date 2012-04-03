module GroupDocs
  module Assembly
    class Questionnaire < GroupDocs::Api::Entity

      require 'groupdocs/assembly/questionnaire/execution'
      require 'groupdocs/assembly/questionnaire/page'
      require 'groupdocs/assembly/questionnaire/question'

      #
      # Returns an array of questionnaires.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Assembly::Questionnaire]
      #
      def self.get!(access = {})
        json = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = '/merge/{{client_id}}/questionnaires'
        end.execute!

        json[:questionnaires].map do |questionnaire|
          GroupDocs::Assembly::Questionnaire.new(questionnaire)
        end
      end

      # Support DSL
      class << self
        alias_method :all!, :get!
      end # << self

      #
      # Returns an array of executions.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Assembly::Questionnaire::Execution>]
      #
      def self.executions!(access = {})
        json = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = '/merge/{{client_id}}/questionnaires/executions'
        end.execute!

        json[:executions].map do |execution|
          GroupDocs::Assembly::Questionnaire::Execution.new(execution)
        end
      end

      # @attr [Integer] id
      attr_accessor :id
      # @attr [String] name
      attr_accessor :name
      # @attr [String] descr
      attr_accessor :descr
      # @attr [Array<GroupDocs::Assembly::Questionnaire::Page>] pages
      attr_accessor :pages

      # Human-readable accessors
      alias_method :description,  :descr
      alias_method :description=, :descr=

      #
      # Adds page to questionnaire.
      #
      # @param [GroupDocs::Assembly::Questionnaire::Page] page
      # @raise [ArgumentError] if page is not GroupDocs::Assembly::Questionnaire::Page object
      #
      def add_page(page)
        page.is_a?(GroupDocs::Assembly::Questionnaire::Page) or raise ArgumentError,
          "Page should be GroupDocs::Assembly::Questionnaire::Page object, received: #{page.inspect}"

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
        json = GroupDocs::Api::Request.new do |request|
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
        GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/merge/{{client_id}}/questionnaires/#{id}"
          request[:request_body] = to_hash
        end.execute!
      end

    end # Questionnaire
  end # Assembly
end # GroupDocs
