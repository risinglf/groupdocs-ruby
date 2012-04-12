module GroupDocs
  class Document < GroupDocs::Api::Entity

    require 'groupdocs/document/annotation'
    require 'groupdocs/document/field'
    require 'groupdocs/document/metadata'
    require 'groupdocs/document/rectangle'
    require 'groupdocs/document/view'

    extend GroupDocs::Api::Sugar::Lookup
    include GroupDocs::Api::Helpers::Access
    include GroupDocs::Api::Helpers::Status

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
      GroupDocs::Storage::File.all!(path, access).map(&:to_document)
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
      api = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/views"
      end
      api.add_params(options)
      json = api.execute!

      json[:views].map do |view|
        GroupDocs::Document::View.new(view)
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
    # @param [Integer] timestamp Unix timestamp
    #
    def process_date=(timestamp)
      @process_date = Time.at(timestamp)
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
      json = GroupDocs::Api::Request.new do |request|
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
      json = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/accessinfo?mode=#{parse_access_mode(mode)}"
      end.execute!

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
      json = GroupDocs::Api::Request.new do |request|
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
      json = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/metadata"
      end.execute!

      GroupDocs::Document::MetaData.new do |metadata|
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
    # @param [Hash] options
    # @option options [Boolean] :include_geometry Set to true if fields location and size should be returned
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::Field>]
    #
    def fields!(options = {}, access = {})
      api = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.guid}/fields"
      end
      api.add_params(options)
      json = api.execute!

      json[:fields].map do |field|
        GroupDocs::Document::Field.new(field)
      end
    end

    #
    # Creates thumbnails of specific pages.
    #
    # @param [Hash] options
    # @option options [Integer] :page_number Starting page
    # @option options [Integer] :page_count Number of pages
    # @option options [Integer] :quality From 1 to 100
    # @option options [Boolean] :use_pdf
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    # @todo what should it return?
    #
    def thumbnail!(options = {}, access = {})
      api = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/doc/{{client_id}}/files/#{file.guid}/thumbnails"
      end
      api.add_params(options)
      api.execute!
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
      json = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/accessinfo"
      end.execute!

      json[:sharers].map do |user|
        GroupDocs::User.new(user)
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
        json = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/doc/{{client_id}}/files/#{file.id}/sharers"
          request[:request_body] = emails
        end.execute!

        json[:shared_users].map do |user|
          GroupDocs::User.new(user)
        end
      end
    end
    # note that aliased version cannot accept access credentials hash
    alias_method :sharers=, :sharers_set!

    #
    # Clears sharers list.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return nil
    #
    def sharers_clear!(access = {})
      GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/doc/{{client_id}}/files/#{file.id}/sharers"
      end.execute![:shared_users]
    end

    #
    # Converts document to given format.
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
      api = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/{{client_id}}/files/#{file.guid}?new_type=#{format}"
      end
      api.add_params(options)
      json = api.execute!

      GroupDocs::Job.new(id: json[:job_id])
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

      api = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/datasources/#{datasource.id}"
      end
      api.add_params(options)
      json = api.execute!

      GroupDocs::Job.new(id: json[:job_id])
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
      json = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/merge/{{client_id}}/files/#{file.guid}/questionnaires"
      end.execute!

      json[:questionnaires].map do |questionnaire|
        GroupDocs::Questionnaire.new(questionnaire)
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

      GroupDocs::Api::Request.new do |request|
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

      json = GroupDocs::Api::Request.new do |request|
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

      GroupDocs::Api::Request.new do |request|
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
      json = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/ant/{{client_id}}/files/#{file.guid}/annotations"
      end.execute!

      json[:annotations].map do |annotation|
        annotation.merge!(document: self)
        GroupDocs::Document::Annotation.new(annotation)
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
      GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/comparison/{{client_id}}/comparison/document?guid=#{file.guid}"
      end.execute!
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
