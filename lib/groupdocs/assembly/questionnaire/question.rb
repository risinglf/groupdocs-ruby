module GroupDocs
  module Assembly
    class Questionnaire::Question < GroupDocs::Api::Entity

      require 'groupdocs/assembly/questionnaire/question/answer'

      TYPES = {
        simple:          0,
        multiple_choice: 1,
      }

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
      # Converts each answer to GroupDocs::Assembly::Questionnaire::Question::Answer object.
      #
      # @param [Array<Hash>] answers
      #
      def answers=(answers)
        if answers
          @answers = answers.map do |answer|
            GroupDocs::Assembly::Questionnaire::Question::Answer.new(answer)
          end
        end
      end

      #
      # Adds answer to the question.
      #
      # @param [GroupDocs::Assembly::Questionnaire::Question::Answer] answer
      # @raise [ArgumentError] if answer is not GroupDocs::Assembly::Questionnaire::Question::Answer object
      #
      def add_answer(answer)
        answer.is_a?(GroupDocs::Assembly::Questionnaire::Question::Answer) or raise ArgumentError,
          "Answer should be GroupDocs::Assembly::Questionnaire::Question::Answer object, received: #{answer.inspect}"

        @answers ||= Array.new
        @answers << answer
      end

      #
      # Updates type with machine-readable format.
      #
      # @param [Symbol] type
      #
      def type=(type)
        type = TYPES[type] if type.is_a?(Symbol)
        @type = type
      end

      #
      # Returns field type in human-readable format.
      #
      # @return [Symbol]
      #
      def type
        TYPES.invert[@type]
      end

    end # Questionnaire::Question
  end # Assembly
end # GroupDocs
