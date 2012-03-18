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
        # @param [Integer] status
        #
        def status=(status)
          @status = STATUSES.invert[status]
        end

      end # Status
    end # Helpers
  end # Api
end # GroupDocs
