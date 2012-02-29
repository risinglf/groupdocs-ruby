require 'base64'
require 'hmac-sha1'
require 'cgi'

module GroupDocs
  module Api
    module Helpers
      module URL

        #
        # Appends path with parameters.
        #
        # @param [Hash] params
        # @api private
        #
        def add_params(params)
          params.each do |param, value|
            options[:path] << "#{separator}#{param}=#{value}"
          end
        end

        private

        #
        # Adds signature to path.
        #
        # @see http://scotland.groupdocs.com/wiki/display/api/URL+Authentication+Using+Signing
        # @api private
        #
        def sign_url
          # calculate a hash of the path with private key
          hash = HMAC::SHA1.new(GroupDocs.private_key)
          hash << options[:path]
          hash = hash.digest
          # convert hash to base64
          hash = Base64.strict_encode64(hash)
          # remove trailing '='
          hash = hash.gsub(/=*$/, '')
          # URL encode hash
          hash = CGI.escape(hash)
          # covert all hexademical characters to upper case
          hash = hash.gsub(/(%[A-Fa-f0-9]{1,2})/) { $1.upcase }

          options[:path] << "#{separator}signature=#{hash}"
        end

        #
        # Returns separator for GET parameters.
        #
        # @return [String] separator - either ? or &
        # @api private
        #
        def separator
          options[:path].include?('?') ? '&' : '?'
        end

        #
        # Prepends path with version number if it's set.
        #
        # @api private
        #
        def prepend_version
          if GroupDocs.api_version
            options[:path] = "/v#{GroupDocs.api_version}#{options[:path]}"
          end
        end

      end # Query
    end # Helpers
  end # Api
end # GroupDocs
