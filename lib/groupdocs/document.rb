module GroupDocs
  class Document < GroupDocs::Api::Entity

    require 'groupdocs/document/field'
    require 'groupdocs/document/metadata'
    require 'groupdocs/document/rectangle'
    require 'groupdocs/document/view'

    extend GroupDocs::Api::Sugar::Lookup

    #
    # Returns an array of all documents on server.
    #
    # @return [Array<GroupDocs::Storage::Document>]
    #
    def self.all!
      GroupDocs::Storage::File.all!.map(&:to_document)
    end

    #
    # Returns an array of views for all documents.
    #
    # @param [Hash] options
    # @option options [Integer] :page_index Page to start with
    # @option options [Integer] :page_size Total number of entries
    #
    # @return [Array<GroupDocs::Document::View>]
    #
    def self.views!(options = { page_index: 0 })
      api = GroupDocs::Api::Request.new do |request|
        request[:method] = :GET
        request[:path] = "/doc/#{GroupDocs.client_id}/views"
      end
      api.add_params(options)
      json = api.execute!

      json[:result][:views].map do |view|
        GroupDocs::Document::View.new(view)
      end
    end

    # @attr [GroupDocs::Storage::File] file
    attr_accessor :file

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
    # @return [Symbol] One of :private, :restricted or :public access modes
    #
    def access_mode!
      json = GroupDocs::Api::Request.new do |request|
        request[:method] = :GET
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.id}/accessinfo"
      end.execute!

      parse_access_mode(json[:result][:access])
    end

    #
    # Sets access mode of document.
    #
    # Please note that even thought it is not "bang" method, it still send requests to API server.
    #
    # @param [Symbol] mode One of :private, :restricted or :public access modes
    # @return [Symbol] Set access mode
    #
    def access_mode=(mode)
      GroupDocs::Api::Request.new do |request|
        request[:method] = :PUT
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.id}/accessinfo?mode=#{parse_access_mode(mode)}"
      end.execute!
    end

    #
    # Returns array of file formats document can be converted to.
    #
    # @return [Array<Symbol>]
    #
    def formats!
      json = GroupDocs::Api::Request.new do |request|
        request[:method] = :GET
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.id}/formats"
      end.execute!

      json[:result][:types].split(';').map do |format|
        format.downcase.to_sym
      end
    end

    #
    # Returns document metadata.
    #
    # @return [GroupDocs::Document::MetaData]
    #
    def metadata!
      json = GroupDocs::Api::Request.new do |request|
        request[:method] = :GET
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.id}/metadata"
      end.execute!

      GroupDocs::Document::MetaData.new do |metadata|
        metadata.id = json[:result][:id]
        metadata.guid = json[:result][:guid]
        metadata.page_count = json[:result][:page_count]
        metadata.views_count = json[:result][:views_count]
        if json[:result][:last_view]
          metadata.last_view = json[:result][:last_view]
          metadata.last_view.document = self
        end
      end
    end

    #
    # Returns an array of document fields.
    #
    # @param [Hash] options
    # @option options [Boolean] :include_geometry Set to true if fields location and size should be returned
    # @return [Array<GroupDocs::Document::Field>]
    #
    def fields!(options = {})
      api = GroupDocs::Api::Request.new do |request|
        request[:method] = :GET
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.guid}/fields"
      end
      api.add_params(options)
      json = api.execute!

      json[:result][:fields].map do |field|
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
    #
    # @todo what should it return?
    #
    def thumbnail!(options = {})
      api = GroupDocs::Api::Request.new do |request|
        request[:method] = :POST
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.guid}/thumbnails"
      end
      api.add_params(options)
      api.execute!
    end

    #
    # Returns an array of users a document is shared with.
    #
    # @return [Array<GroupDocs::User>]
    #
    def sharers!
      json = GroupDocs::Api::Request.new do |request|
        request[:method] = :GET
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.id}/accessinfo"
      end.execute!

      json[:result][:sharers].map do |user|
        GroupDocs::User.new(user)
      end
    end

    #
    # Sets document sharers to given emails.
    #
    # If empty array or nil passed, clears sharers.
    #
    # Please note that even thought it is not "bang" method, it still send requests to API server.
    #
    # @param [Array] emails List of email addresses to share with
    #
    def sharers=(emails)
      if emails.nil? || emails.empty?
        sharers_clear!
      else
        GroupDocs::Api::Request.new do |request|
          request[:method] = :PUT
          request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.id}/sharers"
          request[:request_body] = emails
        end.execute!
      end
    end

    #
    # Clears sharers list.
    #
    # @return nil
    #
    def sharers_clear!
      GroupDocs::Api::Request.new do |request|
        request[:method] = :DELETE
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.id}/sharers"
      end.execute![:result][:shared_users]
    end

    #
    # Converts document to given format.
    #
    # @param [Symbol] format
    # @param [Hash] options
    # @option options [Boolean] :email_results Set to true if converted document should be emailed
    # @return [GroupDocs::Job] Created job
    #
    def convert!(format, options = {})
      api = GroupDocs::Api::Request.new do |request|
        request[:method] = :POST
        request[:path] = "/#{GroupDocs.client_id}/files/#{file.guid}?new_type=#{format}"
      end
      api.add_params(options)
      json = api.execute!

      GroupDocs::Job.new(id: json[:result][:job_id])
    end

    #
    # Try to pass all unknown methods to file.
    #

    def method_missing(method, *args, &blk)
      file.respond_to?(method) ? file.send(method, *args, &blk) : super
    end

    def respond_to?(method)
      super or file.respond_to?(method)
    end

    private

    #
    # @param [Integer, Symbol] mode
    # @api private
    #
    def parse_access_mode(mode)
      modes =  {
        private:    0,
        restricted: 1,
        public:     2
      }

      if mode.is_a?(Integer)
        modes.invert[mode]
      else
        modes[mode]
      end or raise ArgumentError, "Unknown access mode: #{mode.inspect}."
    end

  end # Document
end # GroupDocs
