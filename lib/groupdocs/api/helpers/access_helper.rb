module GroupDocs
  module Api
    module Helpers
      module Access

        MODES = {
          private:    0,
          restricted: 1,
          public:     2
        }

        private

        #
        # Returns client ID from access hash or GroupDocs class variable.
        #
        # @return [String]
        # @raise [NoClientIdError] If Client ID hasn't been set yet, raise exception.
        # @api private
        #
        def client_id
          client_id = options[:access][:client_id] || GroupDocs.client_id
          client_id or raise NoClientIdError, 'Client ID has not been specified.'
        end

        #
        # Returns private key from access hash or GroupDocs class variable.
        #
        # @return [String]
        # @raise [NoPrivateKeyError] If private key hasn't been set yet, raise exception.
        # @api private
        #
        def private_key
          private_key = options[:access][:private_key] || GroupDocs.private_key
          private_key or raise NoPrivateKeyError, 'Private Key has not been specified.'
        end

        #
        # Converts access mode from/to human-readable format.
        #
        # @param [Integer, Symbol] mode
        # @return [Symbol, Integer]
        # @api private
        #
        def parse_access_mode(mode)
          if mode.is_a?(Integer)
            MODES.invert[mode]
          else
            MODES[mode]
          end or raise ArgumentError, "Unknown access mode: #{mode.inspect}."
        end

      end # Access
    end # Helpers
  end # Api
end # GroupDocs
