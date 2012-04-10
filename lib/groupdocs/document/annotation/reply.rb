module GroupDocs
  class Document::Annotation::Reply < GroupDocs::Api::Entity

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
    # Converts timestamp which is return by API server to Time object.
    #
    # @return [Time]
    #
    def replied_on
      Time.at(@repliedOn)
    end

  end # Document::Annotation::Reply
end # GroupDocs
