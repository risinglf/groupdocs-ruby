require 'spec_helper'

describe GroupDocs::Document::Field do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:page)        }
  it { should respond_to(:page=)       }
  it { should respond_to(:name)        }
  it { should respond_to(:name=)       }
  it { should respond_to(:type)        }
  it { should respond_to(:type=)       }
  it { should respond_to(:rectangle)   }
  it { should respond_to(:rectangle=)  }

  it 'is compatible with response JSON' do
    subject.should respond_to(:rect=)
    subject.method(:rect=).should == subject.method(:rectangle=)
  end

  describe '#rectangle=' do
    it 'converts passed hash to GroupDocs::Document::Rectangle object' do
      subject.rectangle = { X: 0.90, Y: 0.05, Width: 0.06745, Height: 0.005967 }
      subject.rectangle.should be_a(GroupDocs::Document::Rectangle)
      subject.rectangle.x.should == 0.90
      subject.rectangle.y.should == 0.05
      subject.rectangle.w.should == 0.06745
      subject.rectangle.h.should == 0.005967
    end
  end
end
