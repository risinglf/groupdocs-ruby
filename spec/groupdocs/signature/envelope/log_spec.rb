require 'spec_helper'

describe GroupDocs::Signature::Envelope::Log do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:id)             }
  it { should respond_to(:id=)            }
  it { should respond_to(:date)           }
  it { should respond_to(:date=)          }
  it { should respond_to(:userName)       }
  it { should respond_to(:userName=)      }
  it { should respond_to(:action)         }
  it { should respond_to(:action=)        }
  it { should respond_to(:remoteAddress)  }
  it { should respond_to(:remoteAddress=) }

  it { should have_alias(:user_name,       :userName)       }
  it { should have_alias(:user_name=,      :userName=)      }
  it { should have_alias(:remote_address,  :remoteAddress)  }
  it { should have_alias(:remote_address=, :remoteAddress=) }

end