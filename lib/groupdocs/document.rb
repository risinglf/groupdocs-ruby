module GroupDocs
  class Document < GroupDocs::Api::Entity

    # @attr [GroupDocs::Storage::File] file
    attr_accessor :file

    # TODO
    attr_accessor :name

    def initialize(options = {}, &blk)
      super(options, &blk)
      file.is_a?(GroupDocs::Storage::File) or raise ArgumentError,
        "You have to pass GroupDocs::Storage::File object: #{file.inspect}"
    end

  end # Document
end # GroupDocs
