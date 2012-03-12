require 'spec_helper'

describe GroupDocs::Document::MetaData do

  it_behaves_like GroupDocs::Api::Entity

  context 'attributes' do
    it { should respond_to(:id)           }
    it { should respond_to(:id=)          }
    it { should respond_to(:guid)         }
    it { should respond_to(:guid=)        }
    it { should respond_to(:page_count)   }
    it { should respond_to(:page_count=)  }
    it { should respond_to(:views_count)  }
    it { should respond_to(:views_count=) }
    it { should respond_to(:last_view)    }
    it { should respond_to(:last_view=)   }
  end
end
