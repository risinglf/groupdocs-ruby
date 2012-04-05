require 'spec_helper'

describe GroupDocs::Questionnaire::Execution do

  it_behaves_like GroupDocs::Api::Entity

  describe 'STATUSES' do
    it 'contains hash of execution statuses' do
      described_class::STATUSES.should == {
        draft:     0,
        submitted: 1,
        executed:  2,
        approved:  3,
        rejected:  4,
        closed:    5,
      }
    end
  end

  it { should respond_to(:id)               }
  it { should respond_to(:id=)              }
  it { should respond_to(:ownerId)          }
  it { should respond_to(:ownerId=)         }
  it { should respond_to(:questionnaireId)  }
  it { should respond_to(:questionnaireId=) }
  it { should respond_to(:executiveId)      }
  it { should respond_to(:executiveId=)     }
  it { should respond_to(:approverId)       }
  it { should respond_to(:approverId=)      }
  it { should respond_to(:datasourceId)     }
  it { should respond_to(:datasourceId=)    }
  it { should respond_to(:documentId)       }
  it { should respond_to(:documentId=)      }
  it { should respond_to(:status)           }
  it { should respond_to(:status=)          }
  it { should respond_to(:guid)             }
  it { should respond_to(:guid=)            }

  it 'has human-readable accessors' do
    subject.should respond_to(:owner_id)
    subject.should respond_to(:owner_id=)
    subject.should respond_to(:questionnaire_id)
    subject.should respond_to(:questionnaire_id=)
    subject.should respond_to(:executive_id)
    subject.should respond_to(:executive_id=)
    subject.should respond_to(:approver_id)
    subject.should respond_to(:approver_id=)
    subject.should respond_to(:datasource_id)
    subject.should respond_to(:datasource_id=)
    subject.should respond_to(:document_id)
    subject.should respond_to(:document_id=)
    subject.method(:owner_id).should          == subject.method(:ownerId)
    subject.method(:owner_id=).should         == subject.method(:ownerId=)
    subject.method(:questionnaire_id).should  == subject.method(:questionnaireId)
    subject.method(:questionnaire_id=).should == subject.method(:questionnaireId=)
    subject.method(:executive_id).should      == subject.method(:executiveId)
    subject.method(:executive_id=).should     == subject.method(:executiveId=)
    subject.method(:approver_id).should       == subject.method(:approverId)
    subject.method(:approver_id=).should      == subject.method(:approverId=)
    subject.method(:datasource_id).should     == subject.method(:datasourceId)
    subject.method(:datasource_id=).should    == subject.method(:datasourceId=)
    subject.method(:document_id).should       == subject.method(:documentId)
    subject.method(:document_id=).should      == subject.method(:documentId=)
  end

  describe '#status=' do
    it 'saves status in machine readable format if symbol is passed' do
      subject.status = :executed
      subject.instance_variable_get(:@status).should == 2
    end

    it 'does nothing if parameter is not symbol' do
      subject.status = 2
      subject.instance_variable_get(:@status).should == 2
    end
  end

  describe '#status' do
    it 'returns status in human-readable format' do
      subject.status = 2
      subject.status.should == :executed
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

    it 'updates status of execution object' do
      lambda do
        subject.set_status!(:submitted)
      end.should change(subject, :status).to(:submitted)
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
