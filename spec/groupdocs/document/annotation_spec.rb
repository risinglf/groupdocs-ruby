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

  describe '#replies=' do
    it 'converts each reply to GroupDocs::Document::Annotation::Reply object if hash is passed' do
      subject.replies = [{  }]
      replies = subject.replies
      replies.should be_an(Array)
      replies.each do |reply|
        reply.should be_a(GroupDocs::Document::Annotation::Reply)
      end
    end

    it 'saves each reply if it is GroupDocs::Document::Annotation::Reply object' do
      reply1 = GroupDocs::Document::Annotation::Reply.new
      reply2 = GroupDocs::Document::Annotation::Reply.new
      subject.replies = [reply1, reply2]
      subject.replies.should include(reply1)
      subject.replies.should include(reply2)
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.replies = nil
      end.should_not change(subject, :replies)
    end
  end

  describe '#add_reply' do
    it 'raises error if reply is not GroupDocs::Document::Annotation::Reply object' do
      -> { subject.add_reply('Reply') }.should raise_error(ArgumentError)
    end

    it 'saves reply' do
      reply = GroupDocs::Document::Annotation::Reply.new
      subject.add_reply(reply)
      subject.replies.should == [reply]
    end
  end

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('annotation_create'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash).and_return({})
      subject.create!
    end

    it 'updated self with response values' do
      lambda do
        subject.create!
      end.should change {
        subject.id
        subject.document_guid
        subject.annotation_guid
        subject.reply_guid
        subject.session_guid
      }
    end
  end
end