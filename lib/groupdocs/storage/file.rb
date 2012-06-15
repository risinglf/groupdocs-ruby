module GroupDocs
  module Storage
    class File < GroupDocs::Api::Entity

      extend Extensions::Lookup
      include Api::Helpers::AccessMode

      DOCUMENT_TYPES = %w(Undefined Cells Words Slides Pdf Html Image)

      #
      # Uploads file to API server.
      #
      # @example
      #   GroupDocs::Storage::File.upload!('resume.pdf', '/folder/cv.pdf', description: 'My resume')
      #
      # @param [String] filepath Path to file to be uploaded
      # @param [String] upload_path Full path to directory to upload file to starting with "/".
      #                      You can also add filename and then uploaded file will use it.
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File]
      #
      # @raise [ArgumentError] If path does not start with /
      #
      def self.upload!(filepath, upload_path = '/', access = {})
        Api::Helpers::Path.verify_starts_with_root(upload_path)
        Api::Helpers::Path.append_file_name(upload_path, filepath)

        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/storage/{{client_id}}/folders#{upload_path}"
          request[:request_body] = Object::File.new(filepath, 'rb')
        end.execute!

        Storage::File.new(json)
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
            files += all!("#{path}/#{entity.name}", access)
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
      # @attr [Integer] file_type
      attr_accessor :file_type
      # @attr [Integer] access
      attr_accessor :access
      # @attr [String] path
      attr_accessor :path

      # Compatibility with response JSON
      alias_method :adj_name=, :name=

      #
      # Updates type with machine-readable format.
      #
      # @param [Symbol] type
      # @raise [ArgumentError] if type is unknown
      #
      def type=(type)
        if type.is_a?(Symbol)
          type = type.to_s.capitalize
          DOCUMENT_TYPES.include?(type) or raise ArgumentError, "Unknown type: #{type.inspect}"
        end

        @type = type
      end

      #
      # Returns type in human-readable format.
      #
      # @return [Symbol]
      #
      def type
        @type.downcase.to_sym
      end

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @return [Time]
      #
      def created_on
        Time.at(@created_on / 1000)
      end

      #
      # Converts access mode to human-readable format.
      #
      # @return [Symbol]
      #
      def access
        parse_access_mode(@access)
      end

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @return [Time]
      #
      def modified_on
        Time.at(@modified_on / 1000)
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
        response = Api::Request.new do |request|
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
      def move!(path, access = {})
        Api::Helpers::Path.verify_starts_with_root(path)
        Api::Helpers::Path.append_file_name(path, name)

        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Move' => id }
          request[:path] = "/storage/{{client_id}}/files#{path}"
        end.execute!

        Storage::File.new(json[:dst_file])
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
        move!("#{path}#{name}", access)
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
      def copy!(path, access = {})
        Api::Helpers::Path.verify_starts_with_root(path)
        Api::Helpers::Path.append_file_name(path, name)

        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Copy' => id }
          request[:path] = "/storage/{{client_id}}/files#{path}"
        end.execute!

        Storage::File.new(json[:dst_file])
      end

      #
      # Compresses file on server to given archive type.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::File] Archive file
      #
      def compress!(access = {})
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/storage/{{client_id}}/files/#{id}/archive/zip"
        end.execute!

        # HACK add filename for further file operations
        json[:name] = "#{name}.zip"
        Storage::File.new(json)
      end

      #
      # Deletes file from server.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def delete!(access = {})
        Api::Request.new do |request|
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
        Document.new(file: self)
      end

    end # File
  end # Storage
end # GroupDocs
