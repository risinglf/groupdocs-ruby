require 'spec_helper'

describe GroupDocs::Document::Annotation::Reply do

  it_behaves_like GroupDocs::Api::Entity

  subject do
    file = GroupDocs::Storage::File.new
    document = GroupDocs::Document.new(file: file)
    annotation = GroupDocs::Document::Annotation.new(document: document)
    described_class.new(annotation: annotation)
  end

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('annotation_replies_get'))
    end

    let(:annotation) do
      document = GroupDocs::Document.new(file: GroupDocs::Storage::File.new)
      GroupDocs::Document::Annotation.new(document: document)
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(annotation, {}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        described_class.get!(annotation, after: Time.now)
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if annotation is not an instance of GroupDocs::Document::Annotation' do
      -> { described_class.get!('Annotation') }.should raise_error(ArgumentError)
    end

    it 'raises error if option :after is not an instance of Time' do
      -> { described_class.get!(annotation, after: 'Yesterday') }.should raise_error(ArgumentError)
    end

    it 'converts option :after to Unix timestamp' do
      time = Time.now
      time.should_receive(:to_i).and_return(1334125808)
      described_class.get!(annotation, after: time)
    end

    it 'returns an array of GroupDocs::Document::Annotation::Reply objects' do
      replies = described_class.get!(annotation)
      replies.should be_an(Array)
      replies.each do |reply|
        reply.should be_a(GroupDocs::Document::Annotation::Reply)
      end
    end
  end

  it { should respond_to(:annotation)      }
  it { should respond_to(:annotation=)     }
  it { should respond_to(:text)            }
  it { should respond_to(:text=)           }
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

  describe '#initialize' do
    it 'raises error if annotation is not specified' do
      -> { described_class.new }.should raise_error(ArgumentError)
    end

    it 'raises error if annotation is not an instance of GroupDocs::Document::Annotation' do
      -> { described_class.new(annotation: '') }.should raise_error(ArgumentError)
    end
  end

  describe '#replied_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.replied_on = 1332950825
      subject.replied_on.should be_a(Time)
    end
  end

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('annotation_replies_create'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'prefers annotation_guid over annotation.guid' do
      subject.annotation_guid = 'abc'
      subject.annotation.guid = 'def'
      subject.annotation.should_not_receive(:guid)
      subject.create!
    end

    it 'updates guid and annotation_guid with response' do
      lambda do
        subject.create!
      end.should change {
        subject.guid
        subject.annotation_guid
      }
    end
  end
end
