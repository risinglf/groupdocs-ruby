module GroupDocs
  module Api
    module Helpers
      module Actions

        ACTIONS = {
          none:                 0,
          convert:              1,
          combine:              2,
          compress_zip:         4,
          compress_rar:         8,
          trace:               16,
          convert_body:        32,
          bind_data:           64,
          print:              128,
          import_annotations: 256,
        }

        #
        # Converts actions array to byte flag.
        #
        # @param [Array<String, Symbol>] actions
        # @return [Integer]
        # @raise [ArgumentError] if actions is not an array
        # @raise [ArgumentError] if action is unknown
        # @api private
        #
        def convert_actions_to_byte(actions)
          actions.is_a?(Array) or raise ArgumentError, "Actions should be an array, received: #{actions.inspect}"
          actions = actions.map(&:to_sym)

          possible_actions = ACTIONS.map { |hash| hash.first }
          actions.each do |action|
            possible_actions.include?(action) or raise ArgumentError, "Unknown action: #{action.inspect}"
          end

          flag = 0
          actions.each do |action|
            flag += ACTIONS[action]
          end

          flag
        end

        #
        # Converts actions byte flag to array.
        #
        # @param [Integer] byte
        # @return [Array<Symbol>]
        # @raise [ArgumentError] if actions is not an array
        # @api private
        #
        def convert_byte_to_actions(byte)
          byte.is_a?(Integer) or raise ArgumentError, "Byte flag should be an integer, received: #{byte.inspect}"

          actions = []
          ACTIONS.reverse_each do |action, flag|
            decreased_byte = byte - flag
            if decreased_byte >= 0
              actions << action
              byte = decreased_byte
            end
          end

          unless actions == [:none]
            actions.delete(:none)
          end

          actions
        end

      end # Actions
    end # Helpers
  end # Api
end # GroupDocs
