module GroupDocs
  class User < Api::Entity

    include Api::Helpers::AccessRights

    #
    # Returns current user profile.
    #
    # @example
    #   user = GroupDocs::User.get!
    #   user.first_name
    #   #=> "John"
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::User]
    #
    def self.get!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/mgmt/{{client_id}}/profile'
      end.execute!

      new(json[:user])
    end

    #
    # Updates user account if it's created, otherwise creates new.
    #
    # @example
    #   user = GroupDocs::User.new
    #   user.primary_email = 'john@smith.com'
    #   user.nickname = 'johnsmith'
    #   user.first_name = 'John'
    #   user.last_name = 'Smith'
    #   # make sure to save user as it has updated attributes
    #   user = GroupDocs::User.update_account!(user)
    #
    # @param [GroupDocs::User] user
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::User]
    #
    def self.update_account!(user, access = {})
      user.is_a?(GroupDocs::User) or raise ArgumentError,
        "User should be GroupDocs::User object, received: #{user.inspect}"

      data = user.to_hash
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/mgmt/{{client_id}}/account/users/#{user.nickname}"
        request[:request_body] = data
      end.execute!

      GroupDocs::User.new data.merge(json)
    end

    #
    # Delete account user.
    #
    # @example
    #   user = GroupDocs::User.get!
    #   GroupDocs::User.delete!(user.users!.last)
    #   #=> "826e3b54e009ce51"
    #
    # @param [GroupDocs::User] user
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [String]
    #
    # @raise [ArgumentError] if user is not GroupDocs::User object
    #
    def self.delete!(user, access = {})
      user.is_a?(GroupDocs::User) or raise ArgumentError,
        "User should be GroupDocs::User object, received: #{user.inspect}"

      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/mgmt/{{client_id}}/account/users/#{user.primary_email}"
      end.execute!

      json[:guid]
    end

    #
    # Generates new user embed key.
    #
    # @example
    #   GroupDocs::User.generate_embed_key!('test-area')
    #   #=> "60a06ef8f23a49cf807977f1444fbdd8"
    #
    # @param [String] area
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [String]
    #
    def self.generate_embed_key!(area, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/mgmt/{{client_id}}/embedkey/new/#{area}"
      end.execute!

      json[:key][:guid]
    end

    #
    # Get user embed key. Generate new embed key if area not exists.
    #
    # @example
    #   GroupDocs::User.get_embed_key!('test-area')
    #   #=> "60a06ef8f23a49cf807977f1444fbdd8"
    #
    # @param [String] area
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [String]
    #
    def self.get_embed_key!(area, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/mgmt/{{client_id}}/embedkey/#{area}"
      end.execute!

      json[:key][:guid]
    end

    #
    # Get area name by embed key.
    #
    # @example
    #   GroupDocs::User.area!('60a06eg8f23a49cf807977f1444fbdd8')
    #   #=> "test-area"
    #
    # @param [String] embed_key
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [String]
    #
    def self.area!(embed_key, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/mgmt/{{client_id}}/embedkey/guid/#{embed_key}"
      end.execute!

      json[:key][:area]
    end

    #
    # Returns an array of storage providers.
    #
    # @example
    #   providers = GroupDocs::User.providers!
    #   providers.first.provider
    #   #=> "Dropbox"
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Storage::Provider>]
    #
    def self.providers!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/mgmt/{{client_id}}/storages'
      end.execute!

      json[:providers].map do |provider|
        Storage::Provider.new(provider)
      end
    end

    #
    # Logins user using user name and password.
    #
    # @example
    #   user = GroupDocs::User.login!('doe@john.com', 'password')
    #   user.first_name
    #   #=> "John"
    #
    # @return [GroupDocs::User]
    #
    def self.login!(email, password)
      json = Api::Request.new do |request|
        request[:sign] = false
        request[:method] = :POST
        request[:path] = "/shared/users/#{email}/logins"
        request[:request_body] = password
      end.execute!

      new(json[:user])
    end

    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [String] nickname
    attr_accessor :nickname
    # @attr [String] firstname
    attr_accessor :firstname
    # @attr [String] lastname
    attr_accessor :lastname
    # @attr [String] primary_email
    attr_accessor :primary_email
    # @attr [String] private_key
    attr_accessor :private_key
    # @attr [String] password_salt
    attr_accessor :password_salt
    # @attr [Integer] claimed_id
    attr_accessor :claimed_id
    # @attr [String] token
    attr_accessor :token
    # @attr [String] storage
    attr_accessor :storage
    # @attr [String] photo
    attr_accessor :photo
    # @attr [Boolean] active
    attr_accessor :active
    # @attr [Boolean] news_enabled
    attr_accessor :news_enabled
    # @attr [Time] signed_up_on
    attr_accessor :signed_up_on
    # @attr [Integer] color
    attr_accessor :color
    # @attr [String] customEmailMessage
    attr_accessor :customEmailMessage

    # Human-readable accessors
    alias_accessor :first_name,           :firstname
    alias_accessor :last_name,            :lastname
    alias_accessor :custom_email_message, :customEmailMessage

    #
    # Converts access rights to human-readable format flag.
    # @return [Array<Symbol>]
    #
    def access_rights
      convert_byte_to_access_rights @access_rights if @access_rights
    end

    #
    # Converts access rights to machine-readable format flag.
    # @param [Array<Symbol>] rights
    #
    def access_rights=(rights)
      if rights.is_a?(Array)
        rights = convert_access_rights_to_byte(rights)
      end
      @access_rights = rights
    end

    #
    # Converts timestamp which is return by API server to Time object.
    #
    # @return [Time]
    #
    def signed_up_on
      Time.at(@signed_up_on / 1000)
    end

    # Compatibility with response JSON
    alias_method :pkey=,       :private_key=
    alias_method :pswd_salt=,  :password_salt=
    alias_method :signedupOn=, :signed_up_on=

    #
    # Updates user profile.
    #
    # @example
    #   user = GroupDocs::User.get!
    #   user.first_name = 'John'
    #   user.last_name = 'Smith'
    #   user.update!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def update!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = '/mgmt/{{client_id}}/profile'
        request[:request_body] = to_hash
      end.execute!
    end

    #
    # Returns an array of users associated to current user account.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::User>]
    #
    def users!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/mgmt/{{client_id}}/account/users'
      end.execute!

      json[:users].map do |user|
        GroupDocs::User.new(user)
      end
    end

    #
    # Returns an array of roles.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def roles!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/mgmt/{{client_id}}/roles'
      end.execute!

      json[:roles]
    end

  end # User
end # GroupDocs
