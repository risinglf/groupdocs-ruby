module GroupDocs
  class Document::Rectangle < Api::Entity

    # @attr [Float] x
    attr_accessor :x
    # @attr [Float] y
    attr_accessor :y
    # @attr [Float] width
    attr_accessor :width
    # @attr [Float] height
    attr_accessor :height

    # Human-readable accessors
    alias_method :w,  :width
    alias_method :w=, :width=
    alias_method :h,  :height
    alias_method :h=, :height=

  end # Document::Rectangle
end # GroupDocs
