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

  it 'has human-readable accessors' do
    subject.should respond_to(:id)
    subject.should respond_to(:id=)
    subject.should respond_to(:min)
    subject.should respond_to(:min=)
    subject.should respond_to(:max)
    subject.should respond_to(:max=)
    subject.should respond_to(:description)
    subject.should respond_to(:description=)
    subject.method(:id).should           == subject.method(:Id)
    subject.method(:id=).should          == subject.method(:Id=)
    subject.method(:min).should          == subject.method(:Min)
    subject.method(:min=).should         == subject.method(:Min=)
    subject.method(:max).should          == subject.method(:Max)
    subject.method(:max=).should         == subject.method(:Max=)
    subject.method(:description).should  == subject.method(:Description)
    subject.method(:description=).should == subject.method(:Description=)
  end
end
