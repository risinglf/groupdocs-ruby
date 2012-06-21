require 'spec_helper'

describe GroupDocs::User do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('user_profile_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::User object' do
      described_class.get!.should be_a(GroupDocs::User)
    end
  end

  it { should respond_to(:id)             }
  it { should respond_to(:id=)            }
  it { should respond_to(:guid)           }
  it { should respond_to(:guid=)          }
  it { should respond_to(:nickname)       }
  it { should respond_to(:nickname=)      }
  it { should respond_to(:firstname)      }
  it { should respond_to(:firstname=)     }
  it { should respond_to(:lastname)       }
  it { should respond_to(:lastname=)      }
  it { should respond_to(:primary_email)  }
  it { should respond_to(:primary_email=) }
  it { should respond_to(:private_key)    }
  it { should respond_to(:private_key=)   }
  it { should respond_to(:password_salt)  }
  it { should respond_to(:password_salt=) }
  it { should respond_to(:claimed_id)     }
  it { should respond_to(:claimed_id=)    }
  it { should respond_to(:token)          }
  it { should respond_to(:token=)         }
  it { should respond_to(:storage)        }
  it { should respond_to(:storage=)       }
  it { should respond_to(:photo)          }
  it { should respond_to(:photo=)         }
  it { should respond_to(:active)         }
  it { should respond_to(:active=)        }
  it { should respond_to(:news_enabled)   }
  it { should respond_to(:news_enabled=)  }
  it { should respond_to(:signed_up_on)   }
  it { should respond_to(:signed_up_on=)  }

  it 'is compatible with response JSON' do
    subject.should respond_to(:pkey=)
    subject.should respond_to(:pswd_salt=)
    subject.should respond_to(:signedupOn=)
    subject.method(:pkey=).should == subject.method(:private_key=)
    subject.method(:pswd_salt=).should == subject.method(:password_salt=)
    subject.method(:signedupOn=).should == subject.method(:signed_up_on=)
  end

  it 'has human-readable accessors' do
    subject.should respond_to(:first_name)
    subject.should respond_to(:first_name=)
    subject.should respond_to(:last_name)
    subject.should respond_to(:last_name=)
    subject.method(:first_name).should  == subject.method(:firstname)
    subject.method(:first_name=).should == subject.method(:firstname=)
    subject.method(:last_name).should   == subject.method(:lastname)
    subject.method(:last_name=).should  == subject.method(:lastname=)
  end

  describe '#signed_up_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.signed_up_on = 1330450135000
      subject.signed_up_on.should == Time.at(1330450135)
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server('{ "result": { "user_guid": "s8dfts8" }, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.update!
    end
  end
end
