require 'spec_helper'

describe GroupDocs::Assembly::Questionnaire::Execution do

  it_behaves_like GroupDocs::Api::Entity

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
end
