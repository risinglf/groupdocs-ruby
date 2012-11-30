require 'spec_helper'

describe GroupDocs::Questionnaire::Execution do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::Status

  it { should respond_to(:id)                  }
  it { should respond_to(:id=)                 }
  it { should respond_to(:guid)                }
  it { should respond_to(:guid=)               }
  it { should respond_to(:questionnaire_id)    }
  it { should respond_to(:questionnaire_id=)   }
  it { should respond_to(:questionnaire_name)  }
  it { should respond_to(:questionnaire_name=) }
  it { should respond_to(:owner)               }
  it { should respond_to(:owner=)              }
  it { should respond_to(:executive)           }
  it { should respond_to(:executive=)          }
  it { should respond_to(:approver)            }
  it { should respond_to(:approver=)           }
  it { should respond_to(:datasource_id)       }
  it { should respond_to(:datasource_id=)      }

  %w(owner executive approver).each do |method|
    describe "##{method}=" do
      it 'converts passed hash to GroupDocs::User object' do
        subject.send(:"#{method}=", { first_name: 'Test' })
        user = subject.send(:"#{method}")
        user.should be_a(GroupDocs::User)
        user.first_name.should == 'Test'
      end

      it 'does nothing if GroupDocs::User is passed' do
        subject.send(:"#{method}=", GroupDocs::User.new(first_name: 'Test'))
        subject.send(:"#{method}").first_name.should == 'Test'
      end
    end
  end

  describe '#set_status!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_execution_status_set'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.set_status!(:submitted, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'parses status' do
      subject.should_receive(:parse_status).with(:submitted).and_return('Submitted')
      subject.set_status!(:submitted)
    end

    it 'updates status of execution object' do
      subject.set_status!(:submitted)
      subject.status.should == :submitted
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_execution_update'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash).and_return({})
      subject.update!
    end
  end
end
