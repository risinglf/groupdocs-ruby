module GroupDocs
  class Document::View < GroupDocs::Api::Entity

    # @attr [GroupDocs::Document] document
    attr_accessor :document
    # @attr [String] short_url
    attr_accessor :short_url
    # @attr [Time] viewed_on
    attr_accessor :viewed_on

    #
    # Converts timestamp which is return by API server to Time object.
    #
    # @param [Integer] timestamp Unix timestamp
    #
    def viewed_on=(timestamp)
      @viewed_on = Time.at(timestamp)
    end

    #
    # Converts passed hash to GroupDocs::Document object.
    #
    # @param [GroupDocs::Document, Hash] object
    # @return [GroupDocs::Document]
    #
    def document=(object)
      if object.is_a?(GroupDocs::Document)
        @document = object
      else
        object.merge!(file: GroupDocs::Storage::File.new(object))
        @document = GroupDocs::Document.new(object)
      end
    end

  end # Document::Metadata
end # GroupDocs
