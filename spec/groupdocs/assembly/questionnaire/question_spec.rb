require 'spec_helper'

describe GroupDocs::Assembly::Questionnaire::Question do

  it_behaves_like GroupDocs::Api::Entity

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
end
