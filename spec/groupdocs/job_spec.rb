require 'spec_helper'

describe GroupDocs::Job do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:id)         }
  it { should respond_to(:id=)        }
  it { should respond_to(:status)     }
  it { should respond_to(:status=)    }
  it { should respond_to(:documents)  }
  it { should respond_to(:documents=) }
end
