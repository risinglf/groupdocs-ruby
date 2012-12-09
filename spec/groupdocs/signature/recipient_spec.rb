require 'spec_helper'

describe GroupDocs::Signature::Recipient do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:id)         }
  it { should respond_to(:id=)        }
  it { should respond_to(:email)      }
  it { should respond_to(:email=)     }
  it { should respond_to(:firstName)  }
  it { should respond_to(:firstName=) }
  it { should respond_to(:lastName)   }
  it { should respond_to(:lastName=)  }
  it { should respond_to(:nickname)   }
  it { should respond_to(:nickname=)  }
  it { should respond_to(:roleId)     }
  it { should respond_to(:roleId=)    }
  it { should respond_to(:order)      }
  it { should respond_to(:order=)     }
  it { should respond_to(:status)     }
  it { should respond_to(:status=)    }

  it { should have_aliased_accessor(:first_name, :firstName) }
  it { should have_aliased_accessor(:last_name,  :lastName)  }
  it { should have_aliased_accessor(:role_id,    :roleId)    }

  describe '#status' do
    it 'converts status to human-readable format' do
      subject.status = 1
      subject.status.should == :notified
    end
  end
end
