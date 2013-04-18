module GroupDocs
  module Storage
    class Provider < Api::Entity
    	
      # @attr [Integer] id
      attr_accessor :id
      # @attr [String] provider
      attr_accessor :provider
      # @attr [String] type
      attr_accessor :type
      # @attr [String] token
      attr_accessor :token
      # @attr [String] publicKey
      attr_accessor :publicKey
      # @attr [String] privateKey
      attr_accessor :privateKey
      # @attr [String] rootFolder
      attr_accessor :rootFolder
      # @attr [Boolean] isPrimary
      attr_accessor :isPrimary
      # @attr [String] serviceHost
      attr_accessor :serviceHost

	  alias_accessor :public_key,   :publicKey
	  alias_accessor :private_key,  :privateKey
	  alias_accessor :root_folder,  :rootFolder
	  alias_accessor :is_primary,   :isPrimary
	  alias_accessor :service_host, :serviceHost

    end # Provider
  end # Storage
end # GroupDocs
