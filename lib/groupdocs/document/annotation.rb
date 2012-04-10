module GroupDocs
  class Document::Annotation < GroupDocs::Api::Entity

    # @attr [GroupDocs::Document] document
    attr_accessor :document
    # @attr [Integer] id
    attr_accessor :id
    # @attr [Integer] annotationGuid
    attr_accessor :annotationGuid
    # @attr [Integer] sessionGuid
    attr_accessor :sessionGuid
    # @attr [Integer] documentGuid
    attr_accessor :documentGuid
    # @attr [Integer] replyGuid
    attr_accessor :replyGuid
    # @attr [Integer] createdOn
    attr_accessor :createdOn
    # @attr [Symbol] type
    attr_accessor :type
    # @attr [Symbol] access
    attr_accessor :access
    # @attr [GroupDocs::Document::Rectangle] box
    attr_accessor :box
    # @attr [Array<GroupDocs::Document::Annotation::Reply>] replies
    attr_accessor :replies

    # Human-readable accessors
    alias_method :annotation_guid,  :annotationGuid
    alias_method :annotation_guid=, :annotationGuid=
    alias_method :session_guid,     :sessionGuid
    alias_method :session_guid=,    :sessionGuid=
    alias_method :document_guid,    :documentGuid
    alias_method :document_guid=,   :documentGuid=
    alias_method :reply_guid,       :replyGuid
    alias_method :reply_guid=,      :replyGuid=
    alias_method :created_on,       :createdOn
    alias_method :created_on=,      :createdOn=

    #
    # Creates new GroupDocs::Document::Annotation.
    #
    # @raise [ArgumentError] If document is not passed or is not an instance of GroupDocs::Document
    #
    def initialize(options = {}, &blk)
      super(options, &blk)
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "You have to pass GroupDocs::Document object: #{document.inspect}."
    end

    #
    # Coverts passed hash to GroupDocs::Document::Rectangle object.
    #
    # @param [Hash] options
    # @return [GroupDocs::Document::Rectangle]
    #
    def box=(options)
      @box = GroupDocs::Document::Rectangle.new(options)
    end

    #
    # Creates new annotation.
    #
    # @example
    #   document = GroupDocs::Document.find!(:name, 'CV.doc')
    #   annotation = GroupDocs::Document::Annotation.new(document: document)
    #   annotation.create!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create!(access = {})
      json = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/ant/{{client_id}}/files/#{document.file.guid}/annotations"
        request[:request_body] = to_hash
      end.execute!

      json.each do |field, value|
        send(:"#{field}=", value) if respond_to?(:"#{field}=")
      end
    end

  end # Document::Annotation
end # GroupDocs
