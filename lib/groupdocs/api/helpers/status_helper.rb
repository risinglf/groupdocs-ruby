module GroupDocs
  module Api
    module Helpers
      module Status

        private

        #
        # Converts status from/to human-readable format.
        #
        # @param [String, Symbol] status
        # @return [Symbol, String]
        # @raise [ArgumentError] if argument is not symbol/string
        # @api private
        #
        def parse_status(status)
          case status
          when Symbol then accessor_to_variable(status).to_s.delete(?@)
          when String then variable_to_accessor(status)
          else raise ArgumentError, "Expected string/symbol, received: #{status.class}"
          end
        end

      end # Status
    end # Helpers
  end # Api
end # GroupDocs
