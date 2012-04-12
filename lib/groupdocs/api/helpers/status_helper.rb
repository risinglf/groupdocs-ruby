module GroupDocs
  module Api
    module Helpers
      module Status

        STATUSES = {
          draft:      -1,
          pending:     0,
          scheduled:   1,
          in_progress: 2,
          completed:   3,
          postponed:   4,
          archived:    5,
        }

        # @attr [Symbol] status
        attr_accessor :status

        #
        # Sets status of the entity.
        #
        # @return [Symbol]
        #
        def status
          parse_status(@status)
        end

        private

        #
        # Converts status from/to human-readable format.
        #
        # @param [Integer, Symbol] status
        # @return [Symbol, Integer]
        # @api private
        #
        def parse_status(status)
          if status.is_a?(Integer)
            STATUSES.invert[status]
          else
            STATUSES[status]
          end or raise ArgumentError, "Unknown status: #{status.inspect}."
        end

      end # Status
    end # Helpers
  end # Api
end # GroupDocs
