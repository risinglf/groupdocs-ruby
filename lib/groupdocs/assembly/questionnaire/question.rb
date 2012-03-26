module GroupDocs
  module Assembly
    class Questionnaire::Question < GroupDocs::Api::Entity

      # @attr [String] field
      attr_accessor :field
      # @attr [String] text
      attr_accessor :text
      # @attr [String] def_answer
      attr_accessor :def_answer
      # @attr [Boolean] required
      attr_accessor :required
      # @attr [Symbol] type
      attr_accessor :type
      # @attr [Array<Hash>] answers
      attr_accessor :answers

      #
      # Adds answer to the question.
      #
      # @example
      #   question.add_answer(text: 'My answer', value: 'Unique value')
      #
      # @param [Hash] answer
      # @raise [ArgumentError] if answer is not of view { text: 'Answer' value: 'Value' }
      #
      def add_answer(answer)
        answer.is_a?(Hash) or raise ArgumentError,
          "Answer should be a hash, received: #{answer.inspect}"
        (answer[:text] && answer[:value]) or raise ArgumentError,
          "Answer should include :text and :value, received: #{answer.inspect}"

        @answers ||= Array.new
        @answers << answer
      end

    end # Questionnaire::Question
  end # Assembly
end # GroupDocs
