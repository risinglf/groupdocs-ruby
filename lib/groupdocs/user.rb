module GroupDocs
  class User < GroupDocs::Api::Entity

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

    # Human-readable accessors
    alias_method :first_name,  :firstname
    alias_method :first_name=, :firstname=
    alias_method :last_name,   :lastname
    alias_method :last_name=,  :lastname=

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

  end # User
end # GroupDocs
