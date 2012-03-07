module GroupDocs
  module Storage
    class Package < GroupDocs::Api::Entity

      # @attr [String] name Package name
      attr_accessor :name
      # @attr [String] url Download package URL
      attr_accessor :url
      # @attr [Array] objects Storage entities to be packed
      attr_accessor :objects

      #
      # Appends object to be packed.
      #
      # @param object GroupDocs::Storage::File or GroupDocs::Storage::Folder to be packed
      #
      def <<(object)
        @objects ||= Array.new
        @objects << object
      end

      #
      # Creates package on server.
      #
      # @return [String] URL of package for downloading
      #
      def create!
        json = GroupDocs::Api::Request.new do |request|
          request[:method] = :POST
          request[:path] = "/storage/#{GroupDocs.client_id}/packages/#{name}.zip"
          request[:request_body] = @objects.map(&:name)
          request[:headers] = { content_type: 'application/json' }
        end.execute!

        json[:result][:url]
      end

    end # Package
  end # Storage
end # GroupDocs
