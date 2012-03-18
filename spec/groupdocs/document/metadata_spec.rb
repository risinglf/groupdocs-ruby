require 'spec_helper'

describe GroupDocs::Document::MetaData do

  it_behaves_like GroupDocs::Api::Entity

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

  describe '#last_view=' do
    it 'converts passed hash to GroupDocs::Document::View object' do
      subject.last_view = { document: { id: 1, name: 'test.pdf' } }
      subject.last_view.should be_a(GroupDocs::Document::View)
      subject.last_view.document.id.should   == 1
      subject.last_view.document.name.should == 'test.pdf'
    end
  end
end
