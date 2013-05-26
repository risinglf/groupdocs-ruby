module GroupDocs
  module Api
    module Helpers
      module SignaturePublic

        private

        #
        # Returns corresponding URI fragment for (un)public call.
        #
        # @param [Boolean, nil] public_flag
        # @return [String]
        # @api private
        #
        def client_id(public_flag)
          !!public_flag ? 'public' : '{{client_id}}'
        end

      end # SignaturePublic
    end # Helpers
  end # Api
end # GroupDocs
