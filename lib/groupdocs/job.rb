module GroupDocs
  class Job < Api::Entity

    extend Api::Helpers::Actions
    include Api::Helpers::Status

    #
    # Returns array of jobs.
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
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/async/{{client_id}}/jobs'
      end
      api.add_params(options)
      json = api.execute!

      json[:jobs].map do |job|
        Job.new(job)
      end
    end

    #
    # Returns job by its identifier.
    #
    # @param [Integer] id
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Job]
    #
    def self.get!(id, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/async/{{client_id}}/jobs/#{id}"
      end.execute!

      Job.new(json)
    end

    #
    # Creates new draft job.
    #
    # @param [Hash] options
    # @option options [Integer] :actions Array of actions to be performed. Required
    # @option options [Boolean] :email_results
    # @option options [Array] :out_formats
    # @option options [Boolean] :url_only
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Job]
    #
    def self.create!(options, access = {})
      options[:actions] or raise ArgumentError, 'options[:actions] is required.'
      options[:actions] = convert_actions_to_byte(options[:actions])
      options[:out_formats] = options[:out_formats].join(?;) if options[:out_formats]

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/async/{{client_id}}/jobs'
        request[:request_body] = options
      end
      json = api.execute!

      Job.new(id: json[:job_id], guid: json[:job_guid])
    end

    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [String] name
    attr_accessor :name
    # @attr [Integer] priority
    attr_accessor :priority
    # @attr [Array<Symbol>] actions
    attr_accessor :actions
    # @attr [Boolean] email_results
    attr_accessor :email_results
    # @attr [Boolean] url_only
    attr_accessor :url_only
    # @attr [Array<GroupDocs::Document] documents
    attr_accessor :documents
    # @attr [Time] requested_time
    attr_accessor :requested_time
    # @attr [Symbol] status
    attr_accessor :status

    #
    # Coverts passed array of attributes hash to array of GroupDocs::Document.
    #
    # @param [Array<Hash>] documents Array of document attributes hashes
    #
    def documents=(documents)
      if documents
        @documents = documents[:inputs].map do |document|
          document.merge!(file: GroupDocs::Storage::File.new(document))
          Document.new(document)
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
    # Converts timestamp which is return by API server to Time object.
    #
    # @return [Time]
    #
    def requested_time
      Time.at(@requested_time / 1000)
    end

    #
    # Returns job actions in human-readable format.
    #
    # @return [Array<Symbol>]
    #
    def actions
      @actions.split(', ').map { |action| variable_to_accessor(action) }
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
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/async/{{client_id}}/jobs/#{id}/documents"
      end.execute!

      self.status = json[:job_status]
      if json[:inputs]
        json[:inputs].map do |document|
          document.merge!(file: GroupDocs::Storage::File.new(document))
          Document.new(document)
        end
      else
        []
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
    #
    # @raise [ArgumentError] If document is not a GroupDocs::Document object
    #
    def add_document!(document, options = {}, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object. Received: #{document.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/async/{{client_id}}/jobs/#{id}/files/#{document.file.guid}"
      end
      api.add_params(options)
      json = api.execute!

      json[:document_id]
    end

    #
    # Deletes document with guid from job.
    #
    # @param [String] guid
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def delete_document!(guid, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/async/{{client_id}}/jobs/#{id}/documents/#{guid}"
      end.execute!
    end

    #
    # Adds datasource to job document.
    #
    # @param [GroupDocs::Document] document
    # @param [GroupDocs::DataSource] datasource
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    # @raise [ArgumentError] If document is not a GroupDocs::Document object
    # @raise [ArgumentError] If datasource is not a GroupDocs::DataSource object
    #
    def add_datasource!(document, datasource, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object. Received: #{document.inspect}"
      datasource.is_a?(GroupDocs::DataSource) or raise ArgumentError,
        "Datasource should be GroupDocs::DataSource object. Received: #{datasource.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/async/{{client_id}}/jobs/#{id}/files/#{document.file.guid}/datasources/#{datasource.id}"
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
      options.merge!(absolute_url: url)

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/async/{{client_id}}/jobs/#{id}/urls"
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
    def update!(options, access = {})
      options[:status] = parse_status(options[:status]) if options[:status]

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/async/{{client_id}}/jobs/#{id}"
        request[:request_body] = options
      end.execute!
    end

    #
    # Deletes draft job.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def delete!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/async/{{client_id}}/jobs/#{id}"
      end.execute!
    end

  end # Job
end # GroupDocs
