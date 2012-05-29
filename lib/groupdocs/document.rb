module GroupDocs
  class Document < GroupDocs::Api::Entity

    require 'groupdocs/document/annotation'
    require 'groupdocs/document/change'
    require 'groupdocs/document/field'
    require 'groupdocs/document/metadata'
    require 'groupdocs/document/rectangle'
    require 'groupdocs/document/view'

    extend Extensions::Lookup
    include Api::Helpers::AccessMode
    include Api::Helpers::Status

    #
    # Returns an array of all documents on server.
    #
    # @param [String] path Starting path to look for documents
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Storage::Document>]
    #
    def self.all!(path = '/', access = {})
      Storage::File.all!(path, access).map(&:to_document)
    end

    #
    # Returns an array of views for all documents.
    #
    # @param [Hash] options
    # @option options [Integer] :page_index Page to start with
    # @option options [Integer] :page_size Total number of entries
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::View>]
    #
    def self.views!(options = { page_index: 0 }, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/views"
      end
      api.add_params(options)
      json = api.execute!

      json[:views].map do |view|
        Document::View.new(view)
      end
    end

    # @attr [GroupDocs::Storage::File] file
    attr_accessor :file
    # @attr [Time] process_date
    attr_accessor :process_date
    # @attr [Array] outputs
    attr_accessor :outputs

    #
    # Converts timestamp which is return by API server to Time object.
    #
    # @return [Time]
    #
    def process_date
      Time.at(@process_date / 1000)
    end

    # Compatibility with response JSON
    alias_method :proc_date=, :process_date=

    #
    # Creates new GroupDocs::Document.
    #
    # You should avoid creating documents directly. Instead, use #to_document
    # instance method of GroupDocs::Storage::File.
    #
    # @raise [ArgumentError] If file is not passed or is not an instance of GroupDocs::Storage::File
    #
    def initialize(options = {}, &blk)
      super(options, &blk)
      file.is_a?(GroupDocs::Storage::File) or raise ArgumentError,
        "You have to pass GroupDocs::Storage::File object: #{file.inspect}."
    end

    #
    # Returns access mode of document.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Symbol] One of :private, :restricted or :public access modes
    #
    def access_mode!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/accessinfo"
      end.execute!

      parse_access_mode(json[:access])
    end

    #
    # Sets access mode of document.
    #
    # @param [Symbol] mode One of :private, :restricted or :public access modes
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Symbol] Set access mode
    #
    def access_mode_set!(mode, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/accessinfo"
      end
      api.add_params(mode: parse_access_mode(mode))
      json = api.execute!

      parse_access_mode(json[:access])
    end
    # note that aliased version cannot accept access credentials hash
    alias_method :access_mode=, :access_mode_set!

    #
    # Returns array of file formats document can be converted to.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<Symbol>]
    #
    def formats!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/formats"
      end.execute!

      json[:types].split(';').map do |format|
        format.downcase.to_sym
      end
    end

    #
    # Returns document metadata.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Document::MetaData]
    #
    def metadata!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/metadata"
      end.execute!

      Document::MetaData.new do |metadata|
        metadata.id = json[:id]
        metadata.guid = json[:guid]
        metadata.page_count = json[:page_count]
        metadata.views_count = json[:views_count]
        if json[:last_view]
          metadata.last_view = json[:last_view]
          metadata.last_view.document = self
        end
      end
    end

    #
    # Returns an array of document fields.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::Field>]
    #
    def fields!(access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.guid}/fields"
      end
      api.add_params(include_geometry: true)
      json = api.execute!

      json[:fields].map do |field|
        Document::Field.new(field)
      end
    end

    #
    # Returns an array of users a document is shared with.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::User>]
    #
    def sharers!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/accessinfo"
      end.execute!

      json[:sharers].map do |user|
        User.new(user)
      end
    end

    #
    # Sets document sharers to given emails.
    #
    # If empty array or nil passed, clears sharers.
    #
    # @param [Array] emails List of email addresses to share with
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::User>]
    #
    def sharers_set!(emails, access = {})
      if emails.nil? || emails.empty?
        sharers_clear!(access)
      else
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/doc/{{client_id}}/files/#{file.id}/sharers"
          request[:request_body] = emails
        end.execute!

        json[:shared_users].map do |user|
          User.new(user)
        end
      end
    end

    #
    # Clears sharers list.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return nil
    #
    def sharers_clear!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/sharers"
      end.execute![:shared_users]
    end

    #
    # Converts document to given format.
    #
    # @example
    #   document = GroupDocs::Document.find!(:name, 'CV.doc')
    #   job = document.convert!(:docx)
    #   sleep(5) # wait for server to finish converting
    #   file = job.documents!.first
    #   file.download!(File.dirname(__FILE__))
    #
    # @param [Symbol] format
    # @param [Hash] options
    # @option options [Boolean] :email_results Set to true if converted document should be emailed
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Job] Created job
    #
    def convert!(format, options = {}, access = {})
      options.merge!(new_type: format)

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/async/{{client_id}}/files/#{file.guid}"
      end
      api.add_params(options)
      json = api.execute!

      Job.new(id: json[:job_id])
    end

    #
    # Creates new job to merge datasource into document.
    #
    # @param [GroupDocs::DataSource] datasource
    # @param [Hash] options
    # @option options [Boolean] :new_type New file format type
    # @option options [Boolean] :email_results Set to true if converted document should be emailed
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Job]
    #
    # @raise [ArgumentError] if datasource is not GroupDocs::DataSource object
    # @raise [ArgumentError] if options does not contain :new_type and/or :email_results
    #
    def datasource!(datasource, options, access = {})
      datasource.is_a?(GroupDocs::DataSource) or raise ArgumentError,
        "Datasource should be GroupDocs::DataSource object, received: #{datasource.inspect}"
      (options[:new_type].nil? || options[:email_results].nil?) and raise ArgumentError,
        "Both :new_type and :email_results should be passed, received: #{options.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/datasources/#{datasource.id}"
      end
      api.add_params(options)
      json = api.execute!

      Job.new(id: json[:job_id])
    end

    #
    # Returns an array of questionnaires.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Questionnaire>]
    #
    def questionnaires!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/questionnaires"
      end.execute!

      json[:questionnaires].map do |questionnaire|
        Questionnaire.new(questionnaire)
      end
    end

    #
    # Adds questionnaire to document.
    #
    # @param [GroupDocs::Questionnaire] questionnaire
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    # @raise [ArgumentError] if questionnaire is not GroupDocs::Questionnaire object
    #
    def add_questionnaire!(questionnaire, access = {})
      questionnaire.is_a?(GroupDocs::Questionnaire) or raise ArgumentError,
        "Questionnaire should be GroupDocs::Questionnaire object, received: #{questionnaire.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/questionnaires/#{questionnaire.id}"
      end.execute!
    end

    #
    # Creates questionnaire and adds it to document.
    #
    # @param [GroupDocs::Questionnaire] questionnaire
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Questionnaire]
    #
    # @raise [ArgumentError] if questionnaire is not GroupDocs::Questionnaire object
    #
    def create_questionnaire!(questionnaire, access = {})
      questionnaire.is_a?(GroupDocs::Questionnaire) or raise ArgumentError,
        "Questionnaire should be GroupDocs::Questionnaire object, received: #{questionnaire.inspect}"

      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/questionnaires"
        request[:request_body] = questionnaire.to_hash
      end.execute!

      questionnaire.id = json[:questionnaire_id]
      questionnaire
    end

    #
    # Detaches questionnaire from document.
    #
    # @param [GroupDocs::Questionnaire] questionnaire
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    # @raise [ArgumentError] if questionnaire is not GroupDocs::Questionnaire object
    #
    def remove_questionnaire!(questionnaire, access = {})
      questionnaire.is_a?(GroupDocs::Questionnaire) or raise ArgumentError,
        "Questionnaire should be GroupDocs::Questionnaire object, received: #{questionnaire.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/questionnaires/#{questionnaire.id}"
      end.execute!
    end

    #
    # Returns an array of annotations.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::Annotation>]
    #
    def annotations!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/ant/{{client_id}}/files/#{file.guid}/annotations"
      end.execute!

      json[:annotations].map do |annotation|
        annotation.merge!(document: self)
        Document::Annotation.new(annotation)
      end
    end

    #
    # Returns document details.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Hash]
    #
    def details!(access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/comparison/{{client_id}}/comparison/document"
      end
      api.add_params(guid: file.guid)
      api.execute!
    end

    #
    # Schedules a job for comparing document with given.
    #
    # @param [GroupDocs::Document] document
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Job]
    #
    # @raise [ArgumentError] if document is not GroupDocs::Document object
    #
    def compare!(document, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/comparison/{{client_id}}/comparison/compare"
      end
      api.add_params(source: file.guid, target: document.file.guid)
      json = api.execute!

      Job.new(id: json[:job_id])
    end

    #
    # Returns an array of changes in document.
    #
    # @example
    #   document_one = GroupDocs::Document.find!(:name, 'CV.doc')
    #   document_two = GroupDocs::Document.find!(:name, 'Resume.doc')
    #   job = document_one.compare!(document_two)
    #   sleep(5) # wait for server to finish comparing
    #   result = job.documents!.first
    #   result.changes!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def changes!(access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/comparison/{{client_id}}/comparison/changes"
      end
      api.add_params(resultFileId: file.guid)
      json = api.execute!

      json[:changes].map do |change|
        Document::Change.new(change)
      end
    end

    #
    # Pass all unknown methods to file.
    #

    def method_missing(method, *args, &blk)
      file.respond_to?(method) ? file.send(method, *args, &blk) : super
    end

    def respond_to?(method)
      super or file.respond_to?(method)
    end

  end # Document
end # GroupDocs
