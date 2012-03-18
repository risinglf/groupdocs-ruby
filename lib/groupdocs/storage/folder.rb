module GroupDocs
  module Storage
    class Folder < GroupDocs::Api::Entity

      extend GroupDocs::Api::Sugar::Lookup
      include GroupDocs::Api::Helpers::Access

      #
      # Creates folder on server.
      #
      # @param [String] path Path of folder to create starting wiht "/"
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::Folder] Created folder
      #
      # @raise [ArgumentError] If path does not start with /
      #
      def self.create!(path, access = {})
        path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{path.inspect}"

        json = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/storage/{{client_id}}/paths#{path}"
        end.execute!

        find!(:id, json[:id], access)
      end

      #
      # Returns an array of all folders on server starting with given path.
      #
      # @param [String] path Starting path to look for folders
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Storage::Folder>]
      #
      def self.all!(path = '/', access = {})
        folders = Array.new
        folder = GroupDocs::Storage::Folder.new(name: path)
        folder.list!({}, access).each do |entity|
          if entity.is_a?(GroupDocs::Storage::Folder)
            folders << entity
            folders += all!("#{path}/#{entity.name}".gsub(/[\/]{2}/, '/'), access)
          end
        end

        folders
      end

      #
      # Returns a list of all directories and files in the path.
      #
      # @param [String] path Path of directory to list starting from root ('/')
      # @param [Hash] options Hash of options
      # @option options [Integer] :page Page to start with
      # @option options [Integer] :count How many items to list
      # @option options [String] :order_by Field name to sort by
      # @option options [Boolean] :order_asc Set to true to return in ascending order
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Storage::Folder, GroupDocs::Storage::File>]
      #
      # @raise [ArgumentError] If path does not start with /
      #
      def self.list!(path = '/', options = {}, access = {})
        path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{path.inspect}"

        api = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/storage/{{client_id}}/folders#{path}"
        end
        api.add_params(options)
        json = api.execute!

        json[:entities].map do |entity|
          if entity[:dir]
            GroupDocs::Storage::Folder.new(entity)
          else
            GroupDocs::Storage::File.new(entity)
          end
        end
      end

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
      # Converts access mode to human-readable format.
      #
      # @param [Integer] mode
      #
      def access=(mode)
        @access = parse_access_mode(mode)
      end

      #
      # Moves folder contents to given path.
      #
      # @param [String] path Destination to move contents to
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [String] Moved to folder path
      #
      # @raise [ArgumentError] If path does not start with /
      #
      def move!(path, access = {})
        path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{path.inspect}"

        GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Move' => name }
          request[:path] = "/storage/{{client_id}}/folders#{path}"
        end.execute!

        path
      end

      #
      # Renames folder to new one.
      #
      # @param [String] name New name
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [String] New name
      #
      def rename!(name, access = {})
        move!("/#{name}", access).sub(/^\//, '')
      end

      #
      # Copies folder contents to a destination path.
      #
      # @param [String] path Path of directory to copy to starting from root ('/')
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [String] Copied to folder path
      #
      # @raise [ArgumentError] If path does not start with /
      #
      def copy!(path, access = {})
        path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{path.inspect}"

        GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:headers] = { :'Groupdocs-Copy' => name }
          request[:path] = "/storage/{{client_id}}/folders#{path}"
        end.execute!

        path
      end

      #
      # Returns an array of files and folders.
      #
      # @param [Hash] options Hash of options
      # @option options [Integer] :page Page to start with
      # @option options [Integer] :count How many items to list
      # @option options [String] :order_by Field name to sort by
      # @option options [Boolean] :order_asc Set to true to return in ascending order
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Storage::Folder, GroupDocs::Storage::File>]
      #
      def list!(options = {}, access = {})
        path = name =~ /^\// ? name : "/#{name}"
        self.class.list!(path, options, access)
      end

      #
      # Creates folder on server.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def create!(access = {})
        self.class.create!("/#{name}", access)
      end

      #
      # Deletes folder from server.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      #
      def delete!(access = {})
        GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/storage/{{client_id}}/folders/#{name}"
        end.execute!
      end

      #
      # Returns an array of users a folder is shared with.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::User>]
      #
      def sharers!(access = {})
        json = GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/doc/{{client_id}}/folders/#{id}/sharers"
        end.execute!

        json[:shared_users].map do |user|
          GroupDocs::User.new(user)
        end
      end

      #
      # Sets folder sharers to given emails.
      #
      # If empty array or nil passed, clears sharers.
      #
      # @param [Array] emails List of email addresses to share with
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::User>]
      #
      def sharers_set!(emails, access = {})
        if emails.nil? || emails.empty?
          sharers_clear!(access)
        else
          json = GroupDocs::Api::Request.new do |request|
            request[:access] = access
            request[:method] = :PUT
            request[:path] = "/doc/{{client_id}}/folders/#{id}/sharers"
            request[:request_body] = emails
          end.execute!

          json[:shared_users].map do |user|
            GroupDocs::User.new(user)
          end
        end
      end
      # note that aliased version cannot accept access credentials hash
      alias_method :sharers=, :sharers_set!

      #
      # Clears sharers list.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return nil
      #
      def sharers_clear!(access = {})
        GroupDocs::Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/doc/{{client_id}}/folders/#{id}/sharers"
        end.execute![:shared_users]
      end

    end # Folder
  end # Storage
end # GroupDocs
