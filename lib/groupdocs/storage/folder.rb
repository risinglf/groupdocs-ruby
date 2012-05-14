module GroupDocs
  module Storage
    class Folder < GroupDocs::Api::Entity

      extend Extensions::Lookup
      include Api::Helpers::AccessMode

      #
      # Creates folder on server.
      #
      # @param [String] path Path of folder to create starting with "/"
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Storage::Folder] Created folder
      #
      def self.create!(path, access = {})
        Api::Helpers::Path.verify_starts_with_root(path)

        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/storage/{{client_id}}/paths#{path}"
        end.execute!

        Storage::Folder.new(json)
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
        folder = GroupDocs::Storage::Folder.new(path: path)
        folder.list!({}, access).each do |entity|
          if entity.is_a?(GroupDocs::Storage::Folder)
            folders << entity
            folders += all!("#{path}/#{entity.name}", access)
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
      def self.list!(path = '/', options = {}, access = {})
        Api::Helpers::Path.verify_starts_with_root(path)
        new(path: path).list!(options, access)
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
      # @attr [String] path
      attr_accessor :path
      # @attr [Integer] version
      attr_accessor :version
      # @attr [Integer] type
      attr_accessor :type
      # @attr [Integer] access
      attr_accessor :access

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @return [Time]
      #
      def created_on
        Time.at(@created_on)
      end

      #
      # Converts timestamp which is return by API server to Time object.
      #
      # @return [Time]
      #
      def modified_on
        Time.at(@modified_on)
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
      # Moves folder contents to given path.
      #
      # @param [String] path Destination to move contents to
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [String] Moved to folder path
      #
      def move!(path, access = {})
        Api::Helpers::Path.verify_starts_with_root(path)

        Api::Request.new do |request|
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
      def copy!(path, access = {})
        Api::Helpers::Path.verify_starts_with_root(path)

        Api::Request.new do |request|
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
        options[:order_by].capitalize! if options[:order_by]

        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/storage/{{client_id}}/folders#{path}/#{name}"
        end
        api.add_params(options)
        json = api.execute!

        folders = json[:folders].map do |folder|
          folder.merge!(path: path)
          Storage::Folder.new(folder)
        end
        files = json[:files].map do |file|
          file.merge!(path: path)
          Storage::File.new(file)
        end

        folders + files
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
        Api::Request.new do |request|
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
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/doc/{{client_id}}/folders/#{id}/sharers"
        end.execute!

        json[:shared_users].map do |user|
          User.new(user)
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
          json = Api::Request.new do |request|
            request[:access] = access
            request[:method] = :PUT
            request[:path] = "/doc/{{client_id}}/folders/#{id}/sharers"
            request[:request_body] = emails
          end.execute!

          json[:shared_users].map do |user|
            User.new(user)
          end
        end
      end

      #
      # Clears sharers list.
      #
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return nil
      #
      def sharers_clear!(access = {})
        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/doc/{{client_id}}/folders/#{id}/sharers"
        end.execute![:shared_users]
      end

    end # Folder
  end # Storage
end # GroupDocs
