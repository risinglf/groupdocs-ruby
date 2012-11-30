require 'spec_helper'

describe GroupDocs::Document::Change do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:id)    }
  it { should respond_to(:id=)   }
  it { should respond_to(:type)  }
  it { should respond_to(:type=) }
  it { should respond_to(:box)   }
  it { should respond_to(:box=)  }
  it { should respond_to(:text)  }
  it { should respond_to(:text=) }
  it { should respond_to(:page)  }
  it { should respond_to(:page=) }

  describe '#type' do
    it 'returns type as symbol' do
      subject.type = 'delete'
      subject.type.should == :delete
    end
  end

  describe '#box=' do
    it 'converts passed hash to GroupDocs::Document::Rectangle object' do
      subject.box = { x: 0.90, y: 0.05, width: 0.06745, height: 0.005967 }
      subject.box.should be_a(GroupDocs::Document::Rectangle)
      subject.box.x.should == 0.90
      subject.box.y.should == 0.05
      subject.box.w.should == 0.06745
      subject.box.h.should == 0.005967
    end
  end
end
