require 'spec_helper'

describe GroupDocs::Document::Annotation do

  it_behaves_like GroupDocs::Api::Entity

  subject do
    file = GroupDocs::Storage::File.new
    document = GroupDocs::Document.new(file: file)
    described_class.new(document: document)
  end

  it { should respond_to(:document)        }
  it { should respond_to(:document=)       }
  it { should respond_to(:id)              }
  it { should respond_to(:id=)             }
  it { should respond_to(:annotationGuid)  }
  it { should respond_to(:annotationGuid=) }
  it { should respond_to(:sessionGuid)     }
  it { should respond_to(:sessionGuid=)    }
  it { should respond_to(:replyGuid)       }
  it { should respond_to(:replyGuid=)      }
  it { should respond_to(:createdOn)       }
  it { should respond_to(:createdOn=)      }
  it { should respond_to(:type)            }
  it { should respond_to(:type=)           }
  it { should respond_to(:access)          }
  it { should respond_to(:access=)         }
  it { should respond_to(:box)             }
  it { should respond_to(:box=)            }
  it { should respond_to(:replies)         }
  it { should respond_to(:replies=)        }

  it 'has human-readable accessors' do
    subject.should respond_to(:annotation_guid)
    subject.should respond_to(:annotation_guid=)
    subject.should respond_to(:session_guid)
    subject.should respond_to(:session_guid=)
    subject.should respond_to(:reply_guid)
    subject.should respond_to(:reply_guid=)
    subject.should respond_to(:created_on)
    subject.should respond_to(:created_on=)
    subject.method(:annotation_guid).should  == subject.method(:annotationGuid)
    subject.method(:annotation_guid=).should == subject.method(:annotationGuid=)
    subject.method(:session_guid).should     == subject.method(:sessionGuid)
    subject.method(:session_guid=).should    == subject.method(:sessionGuid=)
    subject.method(:reply_guid).should       == subject.method(:replyGuid)
    subject.method(:reply_guid=).should      == subject.method(:replyGuid=)
    subject.method(:created_on).should       == subject.method(:createdOn)
    subject.method(:created_on=).should      == subject.method(:createdOn=)
  end

  describe '#initialize' do
    it 'raises error if document is not specified' do
      -> { described_class.new }.should raise_error(ArgumentError)
    end

    it 'raises error if document is not an instance of GroupDocs::Document' do
      -> { described_class.new(document: '') }.should raise_error(ArgumentError)
    end
  end

end
