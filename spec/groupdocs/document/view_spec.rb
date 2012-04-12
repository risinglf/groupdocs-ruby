require 'spec_helper'

describe GroupDocs::Document::View do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:document)     }
  it { should respond_to(:document=)    }
  it { should respond_to(:short_url)    }
  it { should respond_to(:short_url=)   }
  it { should respond_to(:viewed_on)    }
  it { should respond_to(:viewed_on=)   }

  describe '#document=' do
    it 'sets document if GroupDocs::Document object is passed' do
      document = GroupDocs::Document.new(file: GroupDocs::Storage::File.new)
      subject.document = document
      subject.document.should == document
    end

    it 'creates new GroupDocs::Document object from passed hash' do
      subject.document = { id: 1, name: 'test.pdf' }
      document = subject.document
      document.should be_a(GroupDocs::Document)
      document.id.should   == 1
      document.name.should == 'test.pdf'
    end
  end

  describe '#viewed_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.viewed_on = 1330450135
      subject.viewed_on.should be_a(Time)
    end
  end
end
