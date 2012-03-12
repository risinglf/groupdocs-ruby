module GroupDocs
  class Document::Field < GroupDocs::Api::Entity

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
      @rectangle = GroupDocs::Document::Rectangle.new do |rectangle|
        rectangle.x = options[:x]
        rectangle.y = options[:y]
        rectangle.w = options[:w]
        rectangle.h = options[:h]
      end
    end

  end # Document::Field
end # GroupDocs
