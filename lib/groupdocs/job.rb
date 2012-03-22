module GroupDocs
  class Job < GroupDocs::Api::Entity

    include GroupDocs::Api::Helpers::Status

    #
    # Returns array of recent jobs.
    #
    # @param [Hash] options Hash of options
    # @option options [Integer] :page Page to start with
    # @option options [Integer] :count How many items to list
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Job>]
    #
    def self.all!(options = {}, access = {})
      api = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/{{client_id}}/jobs'
      end
      api.add_params(options)
      json = api.execute!

      json[:jobs].map do |job|
        GroupDocs::Job.new(job)
      end
    end

    #
    # Creates new draft job.
    #
    # @param [Hash] options
    # @option options [Integer] :actions Array of actions to be performed. Required
    # @option options [Boolean] :emails_results
    # @option options [Array] :out_formats
    # @option options [Boolean] :url_only
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Job]
    #
    def self.create!(options, access = {})
      options[:actions] or raise ArgumentError, 'options[:actions] is required.'
      options[:actions] = GroupDocs::Api::Helpers::Actions.convert_actions(options[:actions])
      options[:out_formats] = options[:out_formats].join(?;) if options[:out_formats]

      api = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/{{client_id}}/jobs'
        request[:request_body] = options
      end
      json = api.execute!

      GroupDocs::Job.new(id: json[:job_id])
    end

    # @attr [Integer] id
    attr_accessor :id
    # @attr [Array<GroupDocs::Document] documents
    attr_accessor :documents

    #
    # Coverts passed array of attributes hash to array of GroupDocs::Document.
    #
    # @param [Array<Hash>] documents Array of document attributes hashes
    #
    def documents=(documents)
      @documents = documents.map do |document|
        document.merge!(file: GroupDocs::Storage::File.new(document))
        GroupDocs::Document.new(document)
      end
    end

    #
    # Returns an array of documents associated to job.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document>]
    #
    def documents!(access = {})
      json = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/{{client_id}}/jobs/#{id}/documents"
      end.execute!

      json[:documents].map do |document|
        document.merge!(file: GroupDocs::Storage::File.new(document))
        GroupDocs::Document.new(document)
      end
    end

    #
    # Adds document to job.
    #
    # @param [GroupDocs::Document] document
    # @param [Hash] options
    # @option options [Array] :output_formats Array of output formats to override
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Integer] Document ID
    # @raise [ArgumentError] If document is not a GroupDocs::Document object
    #
    def add_document!(document, options = {}, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object. Received: #{document.inspect}"

      api = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/{{client_id}}/jobs/#{id}/files/#{document.file.guid}"
      end
      api.add_params(options)
      json = api.execute!

      json[:document_id]
    end

    #
    # Adds datasource to job document.
    #
    # @param [GroupDocs::Document] document
    # @param [GroupDocs::DataSource] datasource
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] If document is not a GroupDocs::Document object
    # @raise [ArgumentError] If datasource is not a GroupDocs::DataSource object
    #
    # @todo Finish it along with Assembly API
    #
    def add_datasource!(document, datasource, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object. Received: #{document.inspect}"
      datasource.is_a?(GroupDocs::DataSource) or raise ArgumentError,
        "Datasource should be GroupDocs::DataSource object. Received: #{datasource.inspect}"

      GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/{{client_id}}/jobs/#{id}/files/#{document.file.guid}/datasources/#{datasource.id}"
      end.execute!
    end

    #
    # Adds URL of web page or document to be converted.
    #
    # @param [String] url Absolute URL
    # @param [Hash] options
    # @option options [Array] :output_formats Array of output formats to override
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Integer] Document ID
    #
    def add_url!(url, options = {}, access = {})
      api = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/{{client_id}}/jobs/#{id}/urls?absolute_url=#{url}"
      end
      api.add_params(options)
      json = api.execute!

      json[:document_id]
    end

    #
    # Updates job settings and/or status.
    #
    # @param [Hash] options
    # @option options [Boolean] :email_results
    # @option options [Symbol] :status
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    # @todo Receive 400 Bad Request
    #
    def update!(options, access = {})
      options[:status] = parse_status(options[:status]) if options[:status]

      api = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/{{client_id}}/jobs/#{id}"
      end
      api.add_params(options)
      json = api.execute!
    end

  end # Job
end # GroupDocs
