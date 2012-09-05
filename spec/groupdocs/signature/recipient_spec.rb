require 'spec_helper'

describe GroupDocs::Signature::Recipient do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:id)         }
  it { should respond_to(:id=)        }
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

  it { should have_alias(:role_id,  :roleId)  }
  it { should have_alias(:role_id=, :roleId=) }

end
