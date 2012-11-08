module GroupDocs
  class Document::Annotation < Api::Entity

    require 'groupdocs/document/annotation/reply'
    require 'groupdocs/document/annotation/reviewer'

    include Api::Helpers::AccessMode

    TYPES  = %w(Text Area Point TextStrikeout Polyline)

    # @attr [GroupDocs::Document] document
    attr_accessor :document
    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [String] sessionGuid
    attr_accessor :sessionGuid
    # @attr [String] documentGuid
    attr_accessor :documentGuid
    # @attr [String] creatorGuid
    attr_accessor :creatorGuid
    # @attr [String] replyGuid
    attr_accessor :replyGuid
    # @attr [Time] createdOn
    attr_accessor :createdOn
    # @attr [Symbol] type
    attr_accessor :type
    # @attr [Symbol] access
    attr_accessor :access
    # @attr [GroupDocs::Document::Rectangle] box
    attr_accessor :box
    # @attr [Array<GroupDocs::Document::Annotation::Reply>] replies
    attr_accessor :replies
    # @attr [Hash] annotationPosition
    attr_accessor :annotationPosition

    # Compatibility with response JSON
    alias_method :annotationGuid=, :guid=

    # Human-readable accessors
    alias_method :session_guid,         :sessionGuid
    alias_method :session_guid=,        :sessionGuid=
    alias_method :document_guid,        :documentGuid
    alias_method :document_guid=,       :documentGuid=
    alias_method :creator_guid,         :creatorGuid
    alias_method :creator_guid=,        :creatorGuid=
    alias_method :reply_guid,           :replyGuid
    alias_method :reply_guid=,          :replyGuid=
    alias_method :created_on,           :createdOn
    alias_method :created_on=,          :createdOn=
    alias_method :annotation_position,  :annotationPosition
    alias_method :annotation_position=, :annotationPosition=
    alias_method :position,             :annotation_position

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
    # Updates type with machine-readable format.
    #
    # @param [Symbol] type
    # @raise [ArgumentError] if type is unknown
    #
    def type=(type)
      if type.is_a?(Symbol)
        type = accessor_to_variable(type).to_s.delete(?@)
        TYPES.include?(type) or raise ArgumentError, "Unknown type: #{type.inspect}"
      end

      @type = type
    end

    #
    # Returns type in human-readable format.
    #
    # @return [Symbol]
    #
    def type
      variable_to_accessor(@type)
    end

    #
    # Converts access mode to machine-readable format.
    #
    # @param [Symbol] mode
    #
    def access=(mode)
      @access = (mode.is_a?(Symbol) ? parse_access_mode(mode) : mode)
    end

    #
    # Converts access mode to human-readable format.
    #
    # @return [Symbol]
    #
    def access
      parse_access_mode(@access)
    end

    #
    # Converts timestamp which is return by API server to Time object.
    #
    # @return [Time]
    #
    def created_on
      Time.at(@createdOn / 1000)
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
    # Converts each reply to GroupDocs::Document::Annotation::Reply object.
    #
    # @param [Array<GroupDocs::Document::Annotation::Reply, Hash>] replies
    #
    def replies=(replies)
      if replies
        @replies = replies.map do |reply|
          if reply.is_a?(GroupDocs::Document::Annotation::Reply)
            reply
          else
            reply.merge!(annotation: self)
            Document::Annotation::Reply.new(reply)
          end
        end
      end
    end

    #
    # Adds reply to annotation.
    #
    # @param [GroupDocs::Document::Annotation::Reply] reply
    # @raise [ArgumentError] if reply is not GroupDocs::Document::Annotation::Reply object
    #
    def add_reply(reply)
      reply.is_a?(GroupDocs::Document::Annotation::Reply) or raise ArgumentError,
        "Reply should be GroupDocs::Document::Annotation::Reply object, received: #{reply.inspect}"

      @replies ||= Array.new
      @replies << reply
    end

    #
    # Creates new annotation.
    #
    # @example
    #   document = GroupDocs::Storage::Folder.list!.first.to_document
    #   annotation = GroupDocs::Document::Annotation.new(document: document)
    #   annotation.create!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/ant/{{client_id}}/files/#{document.file.guid}/annotations"
        request[:request_body] = to_hash
      end.execute!

      json.each do |field, value|
        send(:"#{field}=", value) if respond_to?(:"#{field}=")
      end
    end

    #
    # Returns annotation collaborators.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::User>]
    #
    def collaborators!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/ant/{{client_id}}/files/#{document.file.guid}/collaborators"
      end.execute!

      json[:collaborators].map do |collaborator|
        User.new(collaborator)
      end
    end

    #
    # Sets annotation collaborators to given emails.
    #
    # @param [Array] emails List of collaborators' email addresses
    # @param [Integer] version Annotation version
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::User>]
    #
    def set_collaborators!(emails, version = 1, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/ant/{{client_id}}/files/#{document.file.guid}/version/#{version}/collaborators"
        request[:request_body] = emails
      end.execute!

      json[:collaborators].map do |collaborator|
        User.new(collaborator)
      end
    end

    #
    # Removes annotation.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def remove!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/ant/{{client_id}}/annotations/#{guid}"
      end.execute!
    end

    #
    # Return an array of replies..
    #
    # @param [Hash] options
    # @option options [Time] :after
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::Annotation::Reply>]
    #
    # @raise [ArgumentError] If :after option is passed but it's not an instance of Time
    #
    def replies!(options = {}, access = {})
      Document::Annotation::Reply.get!(self, options, access)
    end

    #
    # Moves annotation to given coordinates.
    #
    # @param [Integer, Float] x
    # @param [Integer, Float] y
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def move!(x, y, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/ant/{{client_id}}/annotations/#{guid}/position"
        request[:request_body] = { x: x, y: y }
      end.execute!

      self.annotation_position = { x: x, y: y }
    end

    #
    # Moves annotation marker to given coordinates.
    #
    # @param [Integer, Float] x
    # @param [Integer, Float] y
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def move_marker!(x, y, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/ant/{{client_id}}/annotations/#{guid}/markerPosition"
        request[:request_body] = { x: x, y: y }
      end.execute!
    end

    #
    # Sets access mode.
    #
    # @param [Symbol] mode
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def set_access!(mode, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/ant/{{client_id}}/annotations/#{guid}/annotationAccess"
        request[:request_body] = %w(public private).index(mode.to_s)
      end.execute!

      self.access = mode
    end

  end # Document::Annotation
end # GroupDocs
