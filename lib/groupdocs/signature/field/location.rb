module GroupDocs
  class Signature::Field::Location < Api::Entity

    # @attr [String] id
    attr_accessor :id
    # @attr [String] documentId
    attr_accessor :documentId
    # @attr [String] fieldId
    attr_accessor :fieldId
    # @attr [Integer] page (required)
    attr_accessor :page
    # @attr [Float] locationX (required)
    attr_accessor :locationX
    # @attr [Float] locationY (required)
    attr_accessor :locationY
    # @attr [Float] locationWidth (required)
    attr_accessor :locationWidth
    # @attr [Float] locationHeight (required)
    attr_accessor :locationHeight
    # @attr [String] fontName
    attr_accessor :fontName
    # @attr [String] fontColor
    attr_accessor :fontColor
    # @attr [Integer] fontSize
    attr_accessor :fontSize
    # @attr [Boolean] fontBold
    attr_accessor :fontBold
    # @attr [Boolean] fontItalic
    attr_accessor :fontItalic
    # @attr [Boolean] fontUnderline
    attr_accessor :fontUnderline
    # @attr [Boolean] forceNewField
    attr_accessor :forceNewField
    # @attr [String] page
    attr_accessor :page

    # added in realise 1.5.8
    # @attr [Integer] pageWidth
    attr_accessor :pageWidth
    # @attr [Integer] pageHeight
    attr_accessor :pageHeight
    # @attr [Integer] align
    attr_accessor :align


    # Human-readable accessors
    alias_accessor :document_id,     :documentId
    alias_accessor :field_id,        :fieldId
    alias_accessor :location_x,      :locationX
    alias_accessor :x,               :locationX
    alias_accessor :location_y,      :locationY
    alias_accessor :y,               :locationY
    alias_accessor :location_w,      :locationWidth
    alias_accessor :location_width,  :locationWidth
    alias_accessor :w,               :locationWidth
    alias_accessor :location_h,      :locationHeight
    alias_accessor :location_height, :locationHeight
    alias_accessor :h,               :locationHeight
    alias_accessor :font_name,       :fontName
    alias_accessor :font_color,      :fontColor
    alias_accessor :font_size,       :fontSize
    alias_accessor :font_bold,       :fontBold
    alias_accessor :font_italic,     :fontItalic
    alias_accessor :font_underline,  :fontUnderline
    alias_accessor :force_new_field, :forceNewField
    # added in release 1.5.8
    alias_accessor :page_width,         :pageWidth
    alias_accessor :page_height,        :pageHeight

  end # Signature::Field::Location
end # GroupDocs
