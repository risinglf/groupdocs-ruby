module GroupDocs
  class Document::Annotation::Reply < GroupDocs::Api::Entity

    # @attr [GroupDocs::Document::Annotation] annotation
    attr_accessor :annotation
    # @attr [String] text
    attr_accessor :text
    # @attr [String] guid
    attr_accessor :guid
    # @attr [String] annotationGuid
    attr_accessor :annotationGuid
    # @attr [String] userGuid
    attr_accessor :userGuid
    # @attr [String] userName
    attr_accessor :userName
    # @attr [String] text
    attr_accessor :text
    # @attr [Time] repliedOn
    attr_accessor :repliedOn

    # Human-readable accessors
    alias_method :annotation_guid,  :annotationGuid
    alias_method :annotation_guid=, :annotationGuid=
    alias_method :user_guid,        :userGuid
    alias_method :user_guid=,       :userGuid=
    alias_method :user_name,        :userName
    alias_method :user_name=,       :userName=
    alias_method :replied_on,       :repliedOn
    alias_method :replied_on=,      :repliedOn=

    #
    # Creates new GroupDocs::Document::Annotation.
    #
    # @raise [ArgumentError] If document is not passed or is not an instance of GroupDocs::Document
    #
    def initialize(options = {}, &blk)
      super(options, &blk)
      annotation.is_a?(GroupDocs::Document::Annotation) or raise ArgumentError,
        "You have to pass GroupDocs::Document::Annotaion object: #{annotation.inspect}."
    end

    #
    # Converts timestamp which is return by API server to Time object.
    #
    # @return [Time]
    #
    def replied_on
      Time.at(@repliedOn)
    end

    #
    # Creates reply.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    # @raise [NameError] if annotation or annotation_guid are not set
    #
    def create!(access = {})
      guid = annotation_guid || annotation.guid

      json = GroupDocs::Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/ant/{{client_id}}/annotations/#{guid}/replies"
        request[:request_body] = text
      end.execute!

      self.guid            = json[:replyGuid]
      self.annotation_guid = json[:annotationGuid]
    end

  end # Document::Annotation::Reply
end # GroupDocs
