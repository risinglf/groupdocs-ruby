module GroupDocs
  module Storage
    class Folder < GroupDocs::Api::Entity

      # @attr [Integer] id
      attr_accessor :id
      # @attr [Integer] size
      attr_accessor :size
      # @attr [Integer] folder_count
      attr_accessor :folder_count
      # @attr [Integer] file_count
      attr_accessor :file_count
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
      # Moves folder contents to given path.
      #
      # @param [String] path Destination to move contents to
      # @return [String] Moved to folder path
      #
      def move!(path)
        unless path.chars.first == '/'
          raise ArgumentError, "Path should start with /: #{path.inspect}"
        end

        GroupDocs::Api::Request.new do |request|
          request[:method] = :PUT
          request[:headers] = { :'GroupDocs-Move' => name }
          request[:path] = "/storage/#{GroupDocs.client_id}/folders#{path}"
        end.execute!

        path
      end

      #
      # Renames folder to new one.
      #
      # @param [String] name New name
      # @return [String] New name
      #
      def rename!(name)
        move!("/#{name}").gsub(/^\//, '')
      end

      #
      # Copies folder contents to a destination path.
      #
      # @param [String] path Path of directory to list starting from root ('/')
      # @return [String] Copied to folder path
      #
      def copy!(path)
        unless path.chars.first == '/'
          raise ArgumentError, "Path should start with /: #{path.inspect}"
        end

        GroupDocs::Api::Request.new do |request|
          request[:method] = :PUT
          request[:headers] = { :'GroupDocs-Copy' => name }
          request[:path] = "/storage/#{GroupDocs.client_id}/folders#{path}"
        end.execute!

        path
      end

      #
      # Returns an array of files and folders.
      #
      # @param [Hash] options Hash of options
      # @options [Integer] :page Page to start with
      # @options [Integer] :count How many items to list
      # @options [String] :order_by Field name to sort by
      # @options [Boolean] :order_asc Set to true to return in ascending order
      #
      # @return [Array] Array of folders and files. If nothing is listed - empty array.
      #
      def list!(options = {})
        self.class.list!("/#{name}", options)
      end

      #
      # Creates folder on server.
      #
      def create!
        self.class.create!("/#{name}")
      end

      #
      # Deletes folder from server.
      #
      def delete!
        GroupDocs::Api::Request.new do |request|
          request[:method] = :DELETE
          request[:path] = "/storage/#{GroupDocs.client_id}/folders/#{name}"
        end.execute!

        nil
      end


      class << self
        #
        # Returns a list of all directories and files in the path.
        #
        # @param [String] path Path of directory to list starting from root ('/')
        # @param [Hash] options Hash of options
        # @options [Integer] :page Page to start with
        # @options [Integer] :count How many items to list
        # @options [String] :order_by Field name to sort by
        # @options [Boolean] :order_asc Set to true to return in ascending order
        #
        # @return [Array] Array of folders and files. If nothing is listed - empty array.
        #
        def list!(path = '/', options = {})
          api = GroupDocs::Api::Request.new do |request|
            request[:method] = :GET
            request[:path] = "/storage/#{GroupDocs.client_id}/folders#{path}"
          end
          api.add_params(options)
          json = api.execute!

          json[:result][:entities].map do |entity|
            if entity[:dir]
              GroupDocs::Storage::Folder.new do |folder|
                folder.size = entity[:size]
                folder.folder_count = entity[:folder_count]
                folder.file_count = entity[:file_count]
                folder.created_on = entity[:created_on]
                folder.modified_on = entity[:modified_on]
                folder.url = entity[:url]
                folder.name = entity[:name]
                folder.version = entity[:version]
                folder.type = entity[:type]
                folder.access = entity[:access]
                folder.id = entity[:id]
              end
            else
              GroupDocs::Storage::File.new do |file|
                file.size = entity[:size]
                file.known = entity[:known]
                file.thumbnail = entity[:thumbnail]
                file.created_on = entity[:created_on]
                file.modified_on = entity[:modified_on]
                file.url = entity[:url]
                file.name = entity[:name]
                file.version = entity[:version]
                file.type = entity[:type]
                file.access = entity[:access]
                file.id = entity[:id]
                file.guid = entity[:guid]
              end
            end
          end
        end

        #
        # Creates folder on server.
        #
        # @param [String] path Path of folder to create starting from root ('/')
        # @return [GroupDocs::Storage::Folder] Created folder
        #
        def create!(path)
          unless path.chars.first == '/'
            raise ArgumentError, "Path should start with /: #{path.inspect}"
          end

          json = GroupDocs::Api::Request.new do |request|
            request[:method] = :POST
            request[:path] = "/storage/#{GroupDocs.client_id}/paths#{path}"
          end.execute!

          list!.detect { |folder| folder.id == json[:result][:id] }
        end
      end # << self

      def inspect
        %(<##{self.class} @id=#{id} @name="#{name}" @url="#{url}">)
      end

    end # Folder
  end # Storage
end # GroupDocs
