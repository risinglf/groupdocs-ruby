module GroupDocs
  class User < GroupDocs::Api::Entity

    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [String] nickname
    attr_accessor :nickname
    # @attr [String] first_name
    attr_accessor :first_name
    # @attr [String] last_name
    attr_accessor :last_name
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

    #
    # Converts timestamp which is return by API server to Time object.
    #
    # @param [Integer] timestamp Unix timestamp
    #
    def signed_up_on=(timestamp)
      @signed_up_on = Time.at(timestamp)
    end

    # Compatibility with response JSON
    alias_method :pkey=,       :private_key=
    alias_method :pswd_salt=,  :password_salt=
    alias_method :signedupOn=, :signed_up_on=

  end # User
end # GroupDocs
