module GroupDocs
  module Storage
    class File < GroupDocs::Api::Entity

      extend GroupDocs::Api::Sugar::Lookup

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
      # @option options [String] :description Optional description for file
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File]
      #
      # @raise [ArgumentError] If path does not start with /
      #
      def self.upload!(filepath, upload_path = '/', options = {}, access = {})
        upload_path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{upload_path.inspect}"
        upload_path << "/#{Object::File.basename(filepath)}" unless upload_path =~ /\.(\w){3,4}$/

        api = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/storage/{{client_id}}/folders#{upload_path.gsub(/[\/]{2}/, '/')}"
          request[:request_body] = Object::File.new(filepath, 'rb')
        end
        api.add_params(options)
        json = api.execute!

        GroupDocs::Storage::File.new(json)
      end

      #
      # Returns an array of all files on server starting with given path.
      #
      # @param [String] path Starting path to look for files
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Storage::File>]
      #
      def self.all!(path = '/', access = {})
        files = Array.new
        folder = GroupDocs::Storage::Folder.new(path: path)
        folder.list!({}, access).each do |entity|
          if entity.is_a?(GroupDocs::Storage::Folder)
            files += all!("#{path}/#{entity.name}".gsub(/[\/]{2}/, '/'), access)
          else
            files << entity
          end
        end

        files
      end

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

      # Compatibility with response JSON
      alias_method :adj_name=, :name=

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
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [String] Path to downloaded file
      #
      def download!(path, access = {})
        response = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DOWNLOAD
          request[:path] = "/storage/{{client_id}}/files/#{id}"
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
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File] Moved to file
      #
      # @raise [ArgumentError] If path does not start with /
      #
      def move!(path, access = {})
        path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{path.inspect}"
        path << "/#{Object::File.basename(name)}" unless path =~ /\.(\w){3,4}$/

        json = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Move' => id }
          request[:path] = "/storage/{{client_id}}/files#{path}"
        end.execute!

        GroupDocs::Storage::File.new(json[:dst_file])
      end

      #
      # Renames file to new one.
      #
      # @param [String] name New file name
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File] Renamed file
      #
      def rename!(name, access = {})
        move!("/#{name}", access)
      end

      #
      # Moves file to given path.
      #
      # @param [String] path Full path to directory to copy file to starting with "/".
      #                      You can also add filename and then copied file will use it.
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File] Copied to file
      #
      # @raise [ArgumentError] If path does not start with /
      #
      def copy!(path, access = {})
        path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{path.inspect}"
        path << "/#{Object::File.basename(name)}" unless path =~ /\.(\w){3,4}$/

        json = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Copy' => id }
          request[:path] = "/storage/{{client_id}}/files#{path}"
        end.execute!

        GroupDocs::Storage::File.new(json[:dst_file])
      end

      #
      # Compresses file on server to given archive type.
      #
      # @param [Symbol] type Archive type: :zip, :rar.
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File] Archive file
      #
      def compress!(type = :zip, access = {})
        json = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/storage/{{client_id}}/files/#{id}/archive/#{type}"
        end.execute!

        # HACK add filename for further download
        json[:name] = "#{name}.#{type}"
        GroupDocs::Storage::File.new(json)
      end

      #
      # Deletes file from server.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def delete!(access = {})
        GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/storage/{{client_id}}/files/#{guid}"
        end.execute!
      end

      #
      # Converts file to GroupDocs::Document.
      #
      # @return [GroupDocs::Document]
      #
      def to_document
        GroupDocs::Document.new(file: self)
      end

    end # File
  end # Storage
end # GroupDocs
