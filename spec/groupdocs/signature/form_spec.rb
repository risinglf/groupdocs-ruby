require 'spec_helper'

describe GroupDocs::Signature::Form do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Signature::EntityMethods
  include_examples GroupDocs::Signature::ResourceMethods

  describe '.all!' do
    before(:each) do
      mock_api_server(load_json('forms_all'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.all!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      -> { described_class.all!(page: 1, count: 3) }.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::Form objects' do
      forms = described_class.all!
      forms.should be_an(Array)
      forms.each do |form|
        form.should be_a(GroupDocs::Signature::Form)
      end
    end
  end

  it { should respond_to(:id)                          }
  it { should respond_to(:id=)                         }
  it { should respond_to(:name)                        }
  it { should respond_to(:name=)                       }
  it { should respond_to(:ownerGuid)                   }
  it { should respond_to(:ownerGuid=)                  }
  it { should respond_to(:templateGuid)                }
  it { should respond_to(:templateGuid=)               }
  it { should respond_to(:createdTimeStamp)            }
  it { should respond_to(:createdTimeStamp=)           }
  it { should respond_to(:statusDateTime)              }
  it { should respond_to(:statusDateTime=)             }
  it { should respond_to(:documentsCount)              }
  it { should respond_to(:documentsCount=)             }
  it { should respond_to(:documentsPages)              }
  it { should respond_to(:documentsPages=)             }
  it { should respond_to(:participantsCount)           }
  it { should respond_to(:participantsCount=)          }
  it { should respond_to(:fieldsInFinalFileName)       }
  it { should respond_to(:fieldsInFinalFileName=)      }
  it { should respond_to(:canParticipantDownloadForm)  }
  it { should respond_to(:canParticipantDownloadForm=) }

  it { should have_alias(:owner_guid, :ownerGuid)                                       }
  it { should have_alias(:owner_guid=, :ownerGuid=)                                     }
  it { should have_alias(:template_guid, :templateGuid)                                 }
  it { should have_alias(:template_guid=, :templateGuid=)                               }
  it { should have_alias(:created_time_stamp, :createdTimeStamp)                        }
  it { should have_alias(:created_time_stamp=, :createdTimeStamp=)                      }
  it { should have_alias(:status_date_time, :statusDateTime)                            }
  it { should have_alias(:status_date_time=, :statusDateTime=)                          }
  it { should have_alias(:documents_count, :documentsCount)                             }
  it { should have_alias(:documents_count=, :documentsCount=)                           }
  it { should have_alias(:documents_pages, :documentsPages)                             }
  it { should have_alias(:documents_pages=, :documentsPages=)                           }
  it { should have_alias(:participants_count, :participantsCount)                       }
  it { should have_alias(:participants_count=, :participantsCount=)                     }
  it { should have_alias(:fields_in_final_file_name, :fieldsInFinalFileName)            }
  it { should have_alias(:fields_in_final_file_name=, :fieldsInFinalFileName=)          }
  it { should have_alias(:can_participant_download_form, :canParticipantDownloadForm)   }
  it { should have_alias(:can_participant_download_form=, :canParticipantDownloadForm=) }

  describe '#create!' do
    let(:template) { GroupDocs::Signature::Template.new }

    before(:each) do
      mock_api_server(load_json('form_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(template, {}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.create!(template, assembly_id: 'aodfh43yr9834hf943h')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.create!(template)
    end

    it 'updates identifier of entity' do
      lambda do
        subject.create!(template)
      end.should change(subject, :id)
    end

    it 'raises error if template is not GroupDocs::Signature::Template object' do
      -> { subject.create!('Template') }.should raise_error(ArgumentError)
    end
  end

  describe '#documents!' do
    before(:each) do
      mock_api_server(load_json('template_get_documents'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.documents!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Document objects' do
      documents = subject.documents!
      documents.should be_an(Array)
      documents.each do |document|
        document.should be_a(GroupDocs::Document)
      end
    end
  end

  describe '#publish!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.publish!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#complete!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.complete!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#archive!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.archive!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end
end
