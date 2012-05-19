require 'spec_helper'

describe GroupDocs::Document::Rectangle do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:X)       }
  it { should respond_to(:X=)      }
  it { should respond_to(:Y)       }
  it { should respond_to(:Y=)      }
  it { should respond_to(:Width)   }
  it { should respond_to(:Width=)  }
  it { should respond_to(:Height)  }
  it { should respond_to(:Height=) }

  it 'has human-readable accessors' do
    subject.should respond_to(:x)
    subject.should respond_to(:x=)
    subject.should respond_to(:y)
    subject.should respond_to(:y=)
    subject.should respond_to(:w)
    subject.should respond_to(:w=)
    subject.should respond_to(:width)
    subject.should respond_to(:h)
    subject.should respond_to(:h=)
    subject.should respond_to(:height)
    subject.method(:x).should      == subject.method(:X)
    subject.method(:x=).should     == subject.method(:X=)
    subject.method(:y).should      == subject.method(:Y)
    subject.method(:y=).should     == subject.method(:Y=)
    subject.method(:w).should      == subject.method(:Width)
    subject.method(:w=).should     == subject.method(:Width=)
    subject.method(:width).should  == subject.method(:w)
    subject.method(:h).should      == subject.method(:Height)
    subject.method(:h=).should     == subject.method(:Height=)
    subject.method(:height).should == subject.method(:h)
  end
end
