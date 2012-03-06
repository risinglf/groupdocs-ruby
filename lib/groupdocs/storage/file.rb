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
      # @return [String] Path to downloaded file
      #
      def download!(path)
        response = GroupDocs::Api::Request.new do |request|
          request[:method] = :DOWNLOAD
          request[:path] = "/storage/#{GroupDocs.client_id}/files/#{id}"
        end.execute!

        filepath = "#{path}/#{name}"
        Object::File.open(filepath, 'w') do |file|
          file.write(response)
        end

        filepath
      end

      #
      # Moves file to given path.
      #
      # @param [String] path Full path to directory to move file to starting with "/".
      #                      You can also add filename and then moved file will use it.
      # @return [String] Moved to file path
      #
      def move!(path)
        path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{path.inspect}"
        path << Object::File.basename(name) unless path =~ /\.(\w){3,4}$/
        GroupDocs::Api::Request.new do |request|
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Move' => id }
          request[:path] = "/storage/#{GroupDocs.client_id}/files#{path}"
        end.execute!

        path
      end

      #
      # Renames file to new one.
      #
      # @param [String] name New file name
      # @return [String] New name
      #
      def rename!(name)
        move!("/#{name}").sub(/^\//, '')
      end

      #
      # Moves file to given path.
      #
      # @param [String] path Full path to directory to copy file to starting with "/".
      #                      You can also add filename and then copied file will use it.
      # @return [GroupDocs::Storage::File] Copied to file
      #
      def copy!(path)
        path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{path.inspect}"
        path << Object::File.basename(name) unless path =~ /\.(\w){3,4}$/
        json = GroupDocs::Api::Request.new do |request|
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Copy' => id }
          request[:path] = "/storage/#{GroupDocs.client_id}/files#{path}"
        end.execute!

        GroupDocs::Storage::File.new(json[:result][:dst_file])
      end

      #
      # Compresses file on server to given archive type.
      #
      # @param [Symbol] type Archive type: :zip, :rar.
      # @return [GroupDocs::Storage::File] Archive file
      #
      def compress!(type = :zip)
        json = GroupDocs::Api::Request.new do |request|
          request[:method] = :POST
          # TODO type.capitalize should be fixed on server
          request[:path] = "/storage/#{GroupDocs.client_id}/files/#{id}/archive/#{type.capitalize}"
        end.execute!

        # HACK add filename for further download
        json[:result][:name] = "#{name}.#{type}"
        GroupDocs::Storage::File.new(json[:result])
      end

      #
      # Deletes file from server.
      #
      def delete!
        GroupDocs::Api::Request.new do |request|
          request[:method] = :DELETE
          request[:path] = "/storage/#{GroupDocs.client_id}/files/#{guid}"
        end.execute!
      end


      class << self
        #
        # Uploads file to API server.
        #
        # @example
        #   GroupDocs::Storage::File.upload!('resume.pdf', '/folder/cv.pdf', description: 'My resume')
        #
        # @param [String] filepath Path to file to be uploaded
        # @param [String] upload_path Full path to directory to upload file to starting with "/".
        #                      You can also add filename and then uploaded file will use it.
        # @param [Hash] options Hash of options
        # @options [String] :description Optional description for file
        #
        # @return [GroupDocs::Storage::File]
        #
        def upload!(filepath, upload_path = '/', options = {})
          upload_path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{upload_path.inspect}"
          upload_path << Object::File.basename(filepath) unless upload_path =~ /\.(\w){3,4}$/
          api = GroupDocs::Api::Request.new do |request|
            request[:method] = :POST
            request[:path] = "/storage/#{GroupDocs.client_id}/folders#{upload_path}"
            request[:request_body] = Object::File.new(filepath, 'rb')
          end
          api.add_params(options)
          json = api.execute!

          GroupDocs::Storage::File.new do |file|
            file.id        = json[:result][:id]
            file.guid      = json[:result][:guid]
            file.name      = json[:result][:adj_name]
            file.url       = json[:result][:url]
            file.type      = json[:result][:type]
            file.size      = json[:result][:size]
            file.version   = json[:result][:version]
            file.thumbnail = json[:result][:thumbnail]
          end
        end
      end # << self

      def inspect
        %(<##{self.class} @id=#{id} @guid=#{guid} @name="#{name}" @url="#{url}">)
      end

      private

      def recursively_find_all
        raise RuntimeError, 'Not yet implemented!'
      end

    end # File
  end # Storage
end # GroupDocs
