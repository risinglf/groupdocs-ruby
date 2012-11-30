require 'spec_helper'

describe GroupDocs::Questionnaire::Collector do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::Status

  it { should respond_to(:id)                   }
  it { should respond_to(:id=)                  }
  it { should respond_to(:guid)                 }
  it { should respond_to(:guid=)                }
  it { should respond_to(:questionnaire_id)     }
  it { should respond_to(:questionnaire_id=)    }
  it { should respond_to(:type)                 }
  it { should respond_to(:type=)                }
  it { should respond_to(:resolved_executions)  }
  it { should respond_to(:resolved_executions=) }
  it { should respond_to(:emails)               }
  it { should respond_to(:emails=)              }
  it { should respond_to(:modified)             }
  it { should respond_to(:modified=)            }

  describe '#type' do
    it 'returns converted to human-readable format type' do
      subject.should_receive(:parse_status).with('Embedded').and_return(:embedded)
      subject.type = 'Embedded'
      subject.type.should == :embedded
    end
  end

  describe '#modified' do
    it 'returns converted to Time object Unix timestamp' do
      subject.modified = 1330450135000
      subject.modified.should == Time.at(1330450135)
    end
  end
end
