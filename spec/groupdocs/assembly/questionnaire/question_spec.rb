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

  describe '#add_answer' do
    it 'raises error if answer is not Hash object' do
      -> { subject.add_answer('Answer') }.should raise_error(ArgumentError)
    end

    it 'raises error if answer does not have :text' do
      -> { subject.add_answer(value: 'Value') }.should raise_error(ArgumentError)
    end

    it 'raises error if answer does not have :value' do
      -> { subject.add_answer(text: 'Value') }.should raise_error(ArgumentError)
    end

    it 'saves answer' do
      answer = { text: 'Text', value: 'Value' }
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
