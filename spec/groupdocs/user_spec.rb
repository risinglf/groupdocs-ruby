require 'spec_helper'

describe GroupDocs::User do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:id)             }
  it { should respond_to(:id=)            }
  it { should respond_to(:guid)           }
  it { should respond_to(:guid=)          }
  it { should respond_to(:nickname)       }
  it { should respond_to(:nickname=)      }
  it { should respond_to(:first_name)     }
  it { should respond_to(:first_name=)    }
  it { should respond_to(:last_name)      }
  it { should respond_to(:last_name=)     }
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

  describe '#signed_up_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.signed_up_on = 1330450135000
      subject.signed_up_on.should == Time.at(1330450135)
    end
  end
end
