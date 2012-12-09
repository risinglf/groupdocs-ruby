require 'spec_helper'

describe GroupDocs::Subscription::Limit do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:Id)           }
  it { should respond_to(:Id=)          }
  it { should respond_to(:Min)          }
  it { should respond_to(:Min=)         }
  it { should respond_to(:Max)          }
  it { should respond_to(:Max=)         }
  it { should respond_to(:Description)  }
  it { should respond_to(:Description=) }

  it { should have_aliased_accessor(:id, :Id)                   }
  it { should have_aliased_accessor(:min, :Min)                 }
  it { should have_aliased_accessor(:max, :Max)                 }
  it { should have_aliased_accessor(:description, :Description) }
end
