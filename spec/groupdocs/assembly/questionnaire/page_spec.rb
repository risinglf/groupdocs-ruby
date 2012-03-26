require 'spec_helper'

describe GroupDocs::Assembly::Questionnaire::Page do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:questions)  }
  it { should respond_to(:questions=) }
  it { should respond_to(:number)     }
  it { should respond_to(:number=)    }
  it { should respond_to(:title)      }
  it { should respond_to(:title=)     }

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
