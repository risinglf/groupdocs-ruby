module GroupDocs
  class Document::Field < GroupDocs::Api::Entity

    # @attr [Integer] page
    attr_accessor :page
    # @attr [String] name
    attr_accessor :name
    # @attr [String] type
    attr_accessor :type
    # @attr [GroupDocs::Document::Rectangle] rectangle
    attr_accessor :rectangle

    #
    # Coverts passed hash to GroupDocs::Document::Rectangle object.
    #
    # @param [Hash] options
    # @return [GroupDocs::Document::Rectangle]
    #
    def rectangle=(options)
      @rectangle = GroupDocs::Document::Rectangle.new(options)
    end

    # Compatibility with response JSON
    alias_method :rect=, :rectangle=

  end # Document::Field
end # GroupDocs
