module GroupDocs
  module Api
    module Helpers
      module AccessMode

        MODES = {
          private:    0,
          restricted: 1,
          public:     2
        }

        private

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

      end # AccessMode
    end # Helpers
  end # Api
end # GroupDocs
