module GroupDocs
  class Job < GroupDocs::Api::Entity

    # @attr [Integer] id
    attr_accessor :id
    # @attr [Symbol] status
    attr_accessor :status
    # @attr [Array<GroupDocs::Document>] documents
    attr_accessor :documents

  end # Job
end # GroupDocs
