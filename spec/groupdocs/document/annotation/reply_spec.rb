require 'spec_helper'

describe GroupDocs::Document::Annotation::Reply do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:guid)            }
  it { should respond_to(:guid=)           }
  it { should respond_to(:annotationGuid)  }
  it { should respond_to(:annotationGuid=) }
  it { should respond_to(:userGuid)        }
  it { should respond_to(:userGuid=)       }
  it { should respond_to(:userName)        }
  it { should respond_to(:userName=)       }
  it { should respond_to(:text)            }
  it { should respond_to(:text=)           }
  it { should respond_to(:repliedOn)       }
  it { should respond_to(:repliedOn=)      }

  it 'has human-readable accessors' do
    subject.should respond_to(:annotation_guid)
    subject.should respond_to(:annotation_guid=)
    subject.should respond_to(:user_guid)
    subject.should respond_to(:user_guid=)
    subject.should respond_to(:user_name)
    subject.should respond_to(:user_name=)
    subject.should respond_to(:replied_on)
    subject.should respond_to(:replied_on=)
    subject.method(:annotation_guid).should  == subject.method(:annotationGuid)
    subject.method(:annotation_guid=).should == subject.method(:annotationGuid=)
    subject.method(:user_guid).should        == subject.method(:userGuid)
    subject.method(:user_guid=).should       == subject.method(:userGuid=)
    subject.method(:user_name).should        == subject.method(:userName)
    subject.method(:user_name=).should       == subject.method(:userName=)
    # Reply#replied_on is overwritten
    subject.method(:replied_on=).should      == subject.method(:repliedOn=)
  end

  describe '#replied_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.replied_on = 1332950825
      subject.replied_on.should be_a(Time)
    end
  end
end
