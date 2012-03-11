module GroupDocs
  class Document < GroupDocs::Api::Entity

    extend GroupDocs::Api::Sugar::Lookup

    #
    # Returns an array of all documents on server.
    #
    # @return [Array<GroupDocs::Storage::Document>]
    #
    def self.all!
      GroupDocs::Storage::File.all!.map(&:to_document)
    end

    # @attr [GroupDocs::Storage::File] file
    attr_accessor :file

    # TODO
    attr_accessor :name
    attr_accessor :id

    #
    # Creates new GroupDocs::Document.
    #
    # You should avoid creating documents directly. Instead, use #to_document
    # instance method of GroupDocs::Storage::File.
    #
    # @raise [ArgumentError] If file is not passed or is not an instance of GroupDocs::Storage::File
    #
    def initialize(options = {}, &blk)
      super(options, &blk)
      file.is_a?(GroupDocs::Storage::File) or raise ArgumentError,
        "You have to pass GroupDocs::Storage::File object: #{file.inspect}."
    end

    #
    # Returns access mode of document.
    #
    # @return [Symbol] One of :private, :restricted or :public access modes
    #
    def access_mode!
      json = GroupDocs::Api::Request.new do |request|
        request[:method] = :GET
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.id}/accessinfo"
      end.execute!

      parse_access_mode(json[:result][:access])
    end

    #
    # Sets access mode of document.
    #
    # Please note that even thought it is not "bang" method, it still send requests to API server.
    #
    # @param [Symbol] mode One of :private, :restricted or :public access modes
    # @return [Symbol] Set access mode
    #
    def access_mode=(mode)
      GroupDocs::Api::Request.new do |request|
        request[:method] = :PUT
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.id}/accessinfo?mode=#{parse_access_mode(mode)}"
      end.execute!
    end

    #
    # Returns array of file formats document can be converted to.
    #
    # @return [Array<Symbol>]
    #
    def formats!
      json = GroupDocs::Api::Request.new do |request|
        request[:method] = :GET
        request[:path] = "/doc/#{GroupDocs.client_id}/files/#{file.id}/formats"
      end.execute!

      json[:result][:types].split(';').map do |format|
        format.downcase.to_sym
      end
    end

    private

    #
    # @param [Integer, Symbol] mode
    # @api private
    #
    def parse_access_mode(mode)
      modes =  {
        private:    0,
        restricted: 1,
        public:     2
      }

      if mode.is_a?(Integer)
        modes.invert[mode]
      else
        modes[mode]
      end or raise ArgumentError, "Unknown access mode: #{mode.inspect}."
    end

  end # Document
end # GroupDocs
