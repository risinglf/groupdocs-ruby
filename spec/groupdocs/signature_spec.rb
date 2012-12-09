require 'spec_helper'

describe GroupDocs::Signature do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('signatures_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature objects' do
      signatures = described_class.get!
      signatures.should be_an(Array)
      signatures.each do |signature|
        signature.should be_a(GroupDocs::Signature)
      end
    end
  end

  it { should respond_to(:id)                    }
  it { should respond_to(:id=)                   }
  it { should respond_to(:userGuid)              }
  it { should respond_to(:userGuid=)             }
  it { should respond_to(:recipientId)           }
  it { should respond_to(:recipientId=)          }
  it { should respond_to(:name)                  }
  it { should respond_to(:name=)                 }
  it { should respond_to(:companyName)           }
  it { should respond_to(:companyName=)          }
  it { should respond_to(:position)              }
  it { should respond_to(:position=)             }
  it { should respond_to(:firstName)             }
  it { should respond_to(:firstName=)            }
  it { should respond_to(:lastName)              }
  it { should respond_to(:lastName=)             }
  it { should respond_to(:fullName)              }
  it { should respond_to(:fullName=)             }
  it { should respond_to(:textInitials)          }
  it { should respond_to(:textInitials=)         }
  it { should respond_to(:signatureImageFileId)  }
  it { should respond_to(:signatureImageFileId=) }
  it { should respond_to(:initialsImageFileId)   }
  it { should respond_to(:initialsImageFileId=)  }
  it { should respond_to(:signatureImageUrl)     }
  it { should respond_to(:signatureImageUrl=)    }
  it { should respond_to(:initialsImageUrl)      }
  it { should respond_to(:initialsImageUrl=)     }
  it { should respond_to(:createdTimeStamp)      }
  it { should respond_to(:createdTimeStamp=)     }

  it { should have_aliased_accessor(:user_guid, :userGuid)                           }
  it { should have_aliased_accessor(:recipient_id, :recipientId)                     }
  it { should have_aliased_accessor(:company_name, :companyName)                     }
  it { should have_aliased_accessor(:first_name, :firstName)                         }
  it { should have_aliased_accessor(:last_name, :lastName)                           }
  it { should have_aliased_accessor(:full_name, :fullName)                           }
  it { should have_aliased_accessor(:text_initials, :textInitials)                   }
  it { should have_aliased_accessor(:signature_image_file_id, :signatureImageFileId) }
  it { should have_aliased_accessor(:initials_image_file_id, :initialsImageFileId)   }
  it { should have_aliased_accessor(:signature_image_url, :signatureImageUrl)        }
  it { should have_aliased_accessor(:initials_image_url, :initialsImageUrl)          }
  it { should have_aliased_accessor(:created_time_stamp, :createdTimeStamp)          }

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('signature_create'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!('Signature', client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.create!('Signature')
    end

    it 'updates identifier of signature' do
      lambda do
        subject.create!('Signature')
      end.should change(subject, :id)
    end
  end

  describe '#delete!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end
end
