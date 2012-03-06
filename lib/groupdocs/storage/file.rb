module GroupDocs
  module Storage
    class File < GroupDocs::Api::Entity

      # @attr [Integer] id
      attr_accessor :id
      # @attr [Integer] guid
      attr_accessor :guid
      # @attr [Integer] size
      attr_accessor :size
      # @attr [Boolean] known
      attr_accessor :known
      # @attr [String] thumbnail
      attr_accessor :thumbnail
      # @attr [Time] created_on
      attr_accessor :created_on
      # @attr [Time] modified_on
      attr_accessor :modified_on
      # @attr [String] url
      attr_accessor :url
      # @attr [String] name
      attr_accessor :name
      # @attr [Integer] version
      attr_accessor :version
      # @attr [Integer] type
      attr_accessor :type
      # @attr [Integer] access
      attr_accessor :access

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @param [Integer] timestamp Unix timestamp
      #
      def created_on=(timestamp)
        @created_on = Time.at(timestamp)
      end

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @param [Integer] timestamp Unix timestamp
      #
      def modified_on=(timestamp)
        @modified_on = Time.at(timestamp)
      end

      #
      # Downloads file to given path.
      #
      # @param [String] path Directory to download file to
      #
      def download!(path)
        response = GroupDocs::Api::Request.new do |request|
          request[:method] = :DOWNLOAD
          request[:path] = "/storage/#{GroupDocs.client_id}/files/#{id}"
        end.execute!

        File.open("#{path}/#{name}", 'w') do |file|
          file.write(response)
        end
      end

      class << self
        #
        # Uploads file to API server.
        #
        # @example
        #   GroupDocs::Storage::File.upload!('resume.pdf', '/folder/cv.pdf', description: 'My resume')
        #
        # @param [String] file Path to file to be uploaded
        # @param [String] path Full path to directory to upload file to.
        #                      You can also add filename and then uploaded file will use it.
        # @param [Hash] options Hash of options
        # @options [String] :description Optional description for file
        #
        # @return [GroupDocs::Storage::File]
        #
        def upload!(file, path, options = {})
          api = GroupDocs::Api::Request.new do |request|
            request[:method] = :POST
            request[:path] = "/storage/#{GroupDocs.client_id}/folders#{path}"
            request[:request_body] = { upload: Object::File.new(file, 'rb') }
          end
          api.add_params(options)
          json = api.execute!

          GroupDocs::Storage::File.new do |file|
            file.id = json[:result][:id]
            file.guid = json[:result][:guid]
            file.name = json[:result][:adj_name]
            file.url = json[:result][:url]
            file.type = json[:result][:type]
            file.size = json [:result][:size]
            file.version = json [:result][:version]
            file.thumbnail = json[:result][:thumbnail]
          end
        end
      end # << self

      def inspect
        %(<##{self.class} @id=#{id} @guid=#{guid} @name="#{name}" @url="#{url}">)
      end

    end # File
  end # Storage
end # GroupDocs
