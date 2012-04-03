require 'spec_helper'

describe GroupDocs::Assembly::Questionnaire::Question do

  it_behaves_like GroupDocs::Api::Entity

  describe 'TYPES' do
    it 'contains hash of field types' do
      described_class::TYPES.should == {
        simple:          0,
        multiple_choice: 1,
      }
    end
  end

  it { should respond_to(:field)       }
  it { should respond_to(:field=)      }
  it { should respond_to(:text)        }
  it { should respond_to(:text=)       }
  it { should respond_to(:def_answer)  }
  it { should respond_to(:def_answer=) }
  it { should respond_to(:required)    }
  it { should respond_to(:required=)   }
  it { should respond_to(:type)        }
  it { should respond_to(:type=)       }
  it { should respond_to(:answers)     }
  it { should respond_to(:answers=)    }

  describe '#answers=' do
    it 'converts each answer to GroupDocs::Assembly::Questionnaire::Question::Answer object' do
      subject.answers = [{ text: 'Text1', value: 'Value1' }, { text: 'Text2', value: 'Value2' }]
      answers = subject.answers
      answers.should be_an(Array)
      answers.each do |answer|
        answer.should be_a(GroupDocs::Assembly::Questionnaire::Question::Answer)
      end
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.answers = nil
      end.should_not change(subject, :answers)
    end
  end

  describe '#add_answer' do
    it 'raises error if answer is not GroupDocs::Assembly::Questionnaire::Question::Answer object' do
      -> { subject.add_answer('Answer') }.should raise_error(ArgumentError)
    end

    it 'saves answer' do
      answer = GroupDocs::Assembly::Questionnaire::Question::Answer.new(text: 'Text', value: 'Value')
      subject.add_answer(answer)
      subject.answers.should == [answer]
    end
  end

  describe '#type=' do
    it 'saves type in machine readable format if symbol is passed' do
      subject.type = :multiple_choice
      subject.instance_variable_get(:@type).should == 1
    end

    it 'does nothing if parameter is not symbol' do
      subject.type = 1
      subject.instance_variable_get(:@type).should == 1
    end
  end

  describe '#type' do
    it 'returns type in human-readable format' do
      subject.type = 1
      subject.type.should == :multiple_choice
    end
  end
end
