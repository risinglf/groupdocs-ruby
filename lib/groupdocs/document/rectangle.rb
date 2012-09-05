module GroupDocs
  class Document::Rectangle < Api::Entity

    # @attr [Float] X
    attr_accessor :X
    # @attr [Float] Y
    attr_accessor :Y
    # @attr [Float] Width
    attr_accessor :Width
    # @attr [Float] Height
    attr_accessor :Height

    # Human-readable accessors
    alias_method :x,      :X
    alias_method :x=,     :X=
    alias_method :y,      :Y
    alias_method :y=,     :Y=
    alias_method :w,      :Width
    alias_method :w=,     :Width=
    alias_method :width,  :w
    alias_method :h,      :Height
    alias_method :h=,     :Height=
    alias_method :height, :Height

  end # Document::Rectangle
end # GroupDocs
