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
  it { should respond_to(:documentGuid)    }
  it { should respond_to(:documentGuid=)   }
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
    subject.should respond_to(:document_guid)
    subject.should respond_to(:document_guid=)
    subject.should respond_to(:reply_guid)
    subject.should respond_to(:reply_guid=)
    subject.should respond_to(:created_on)
    subject.should respond_to(:created_on=)
    subject.method(:annotation_guid).should  == subject.method(:annotationGuid)
    subject.method(:annotation_guid=).should == subject.method(:annotationGuid=)
    subject.method(:session_guid).should     == subject.method(:sessionGuid)
    subject.method(:session_guid=).should    == subject.method(:sessionGuid=)
    subject.method(:document_guid).should    == subject.method(:documentGuid)
    subject.method(:document_guid=).should   == subject.method(:documentGuid=)
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

  describe '#box=' do
    it 'converts passed hash to GroupDocs::Document::Rectangle object' do
      subject.box = { X: 0.90, Y: 0.05, Width: 0.06745, Height: 0.005967 }
      subject.box.should be_a(GroupDocs::Document::Rectangle)
      subject.box.x.should == 0.90
      subject.box.y.should == 0.05
      subject.box.w.should == 0.06745
      subject.box.h.should == 0.005967
    end
  end

  describe '#create!' do
    pending
  end
end
