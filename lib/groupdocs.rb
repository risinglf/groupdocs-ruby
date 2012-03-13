require 'groupdocs/version'
require 'groupdocs/errors'
require 'groupdocs/api'
require 'groupdocs/storage'
require 'groupdocs/document'
require 'groupdocs/user'

module GroupDocs
  class << self

    # @attr_writer [String] client_id Client ID
    attr_writer :client_id

    # @attr_writer [String] private_key Private key
    attr_writer :private_key

    # @attr_writer [String] api_server API server
    attr_writer :api_server

    # @attr [String] api_version Version of API server
    attr_accessor :api_version

    #
    # Returns Client ID.
    #
    # @return [String] Client ID
    # @raise [NoClientIdError] If Client ID hasn't been set yet, raise exception.
    #
    def client_id
      @client_id or raise Errors::NoClientIdError, 'Client ID has not been specified.'
    end

    #
    # Returns Private key.
    #
    # @return [String] Private key
    # @raise [NoPrivateKeyError] If private key hasn't been set yet, raise exception.
    #
    def private_key
      @private_key or raise Errors::NoPrivateKeyError, 'Private Key has not been specified.'
    end

    #
    # Returns hostname of API server.
    #
    # @return [String] API hostname. Default one if it has not been explicitly set
    #
    def api_server
      @api_server || 'https://dev-api.groupdocs.com'
    end

    #
    # Calls block for configuration of GroupDocs.
    #
    # @example Configure GroupDocs
    #   GroupDocs.configure do |groupdocs|
    #     groupdocs.client_id = '07aaaf95f8eb33a4'
    #     groupdocs.private_key = '5cb711b3a52ffc5d90ee8a0f79206f5a'
    #     groupdocs.api_server = 'https://api.groupdocs.com'
    #     groupdocs.api_version = '2.0'
    #   end
    #
    # @yield [GroupDocs]
    #
    def configure(&blk)
      blk.call(self)
    end

  end # << self
end # GroupDocs
