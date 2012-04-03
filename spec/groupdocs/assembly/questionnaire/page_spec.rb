require 'spec_helper'

describe GroupDocs::Assembly::Questionnaire::Page do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:questions)  }
  it { should respond_to(:questions=) }
  it { should respond_to(:number)     }
  it { should respond_to(:number=)    }
  it { should respond_to(:title)      }
  it { should respond_to(:title=)     }

  describe '#questions=' do
    it 'converts each question to GroupDocs::Assembly::Questionnaire::Question object' do
      subject.questions = [{ field: 'Field1', text: 'Text1', def_answer: 'A1' }]
      questions = subject.questions
      questions.should be_an(Array)
      questions.each do |question|
        question.should be_a(GroupDocs::Assembly::Questionnaire::Question)
      end
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.questions = nil
      end.should_not change(subject, :questions)
    end
  end

  describe '#add_question' do
    it 'raises error if page is not GroupDocs::Assembly::Questionnaire::Page object' do
      -> { subject.add_question('Page') }.should raise_error(ArgumentError)
    end

    it 'saves question' do
      question = GroupDocs::Assembly::Questionnaire::Question.new
      subject.add_question(question)
      subject.questions.should == [question]
    end
  end
end
