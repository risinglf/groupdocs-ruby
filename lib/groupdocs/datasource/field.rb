module GroupDocs
  class DataSource::Field < GroupDocs::Api::Entity

    TYPES = {
      text:   0,
      binary: 1,
    }

    # @attr [String] field
    attr_accessor :field
    # @attr [Integer] type
    attr_accessor :type
    # @attr [Array<String>] values
    attr_accessor :values

    # Compatibility with response JSON
    alias_method :name=, :field=

    #
    # Updates type with machine-readable format.
    #
    # @param [Symbol] type
    # @raise [ArgumentError] if type is unknown
    #
    def type=(type)
      if type.is_a?(Symbol)
        TYPES.keys.include?(type) or raise ArgumentError, "Unknown type: #{type.inspect}"
        type = TYPES[type]
      end

      @type = type
    end

    #
    # Returns field type in human-readable format.
    #
    # @return [Symbol]
    #
    def type
      TYPES.invert[@type]
    end

  end # DataSource::Field
end # GroupDocs
