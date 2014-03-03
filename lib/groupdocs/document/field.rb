module GroupDocs
  class Document::Field < Api::Entity

    # @attr [Integer] page
    attr_accessor :page
    # @attr [String] name
    attr_accessor :name
    # @attr [String] type
    attr_accessor :type
    # @attr [GroupDocs::Document::Rectangle] rect
    attr_accessor :rect
    # @attr [Int] maxlength
    attr_accessor :maxlength
    # @attr [Boolean] mandatory
    attr_accessor :mandatory
    # @attr [String] fieldtype
    attr_accessor :fieldtype
    # @attr [Array] acceptableValues
    attr_accessor :acceptableValues

    #
    # Coverts passed hash to GroupDocs::Document::Rectangle object.
    # @param [Hash] options
    #
    def rect=(rectangle)
      if rectangle.is_a?(Hash)
        rectangle = GroupDocs::Document::Rectangle.new(rectangle)
      end

      @rect = rectangle
    end

    # Human-readable accessors
    alias_accessor :rectangle, :rect

  end # Document::Field
end # GroupDocs
