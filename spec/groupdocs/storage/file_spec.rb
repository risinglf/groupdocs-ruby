require 'spec_helper'

describe GroupDocs::Storage::File do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Sugar::Lookup

  describe '.upload!' do
    before(:each) do
      mock_api_server(load_json('file_upload'))
    end

    it 'accepts options hash' do
      lambda do
        described_class.upload!(__FILE__, '/upload_path', { description: 'Description' })
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.upload!(__FILE__, '/upload_path', {}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if upload path does not start with /' do
      -> { described_class.upload!('test', 'upload_path') }.should raise_error(ArgumentError)
    end

    it 'appends filename to upload path if it is not passed' do
      upload_path = '/upload_path'
      upload_path.should_receive(:<<).with("/#{File.basename(__FILE__)}")
      described_class.upload!(__FILE__, upload_path)
    end

    it 'returns GroupDocs::Storage::File object' do
      described_class.upload!(__FILE__).should be_a(GroupDocs::Storage::File)
    end
  end

  it { should respond_to(:id)           }
  it { should respond_to(:id=)          }
  it { should respond_to(:guid)         }
  it { should respond_to(:guid=)        }
  it { should respond_to(:known)        }
  it { should respond_to(:known=)       }
  it { should respond_to(:size)         }
  it { should respond_to(:size=)        }
  it { should respond_to(:thumbnail)    }
  it { should respond_to(:thumbnail=)   }
  it { should respond_to(:created_on)   }
  it { should respond_to(:created_on=)  }
  it { should respond_to(:modified_on)  }
  it { should respond_to(:modified_on=) }
  it { should respond_to(:url)          }
  it { should respond_to(:url=)         }
  it { should respond_to(:name)         }
  it { should respond_to(:name=)        }
  it { should respond_to(:version)      }
  it { should respond_to(:version=)     }
  it { should respond_to(:type)         }
  it { should respond_to(:type=)        }
  it { should respond_to(:access)       }
  it { should respond_to(:access=)      }
  it { should respond_to(:path)         }
  it { should respond_to(:path=)        }

  it 'is compatible with response JSON' do
    subject.should respond_to(:adj_name=)
    subject.method(:adj_name=).should == subject.method(:name=)
  end

  describe '#created_on' do
    it 'converts timestamp to Time object' do
      subject.created_on = 1330450135
      subject.created_on.should be_a(Time)
    end
  end

  describe '#modified_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.modified_on = 1330450135
      subject.modified_on.should be_a(Time)
    end
  end

  describe '#download!' do
    before(:each) do
      mock_api_server(File.read('spec/support/files/resume.pdf'))
      subject.stub(name: 'resume.pdf')
    end

    let(:path) { Dir.tmpdir }

    it 'accepts access credentials hash' do
      lambda do
        subject.download!(path, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'downloads file to given path' do
      file = stub('file')
      Object::File.should_receive(:open).with("#{path}/resume.pdf", 'w').and_yield(file)
      file.should_receive(:write).with(File.read('spec/support/files/resume.pdf'))
      subject.download!(path)
    end

    it 'returns saved file path' do
      subject.download!(path).should == "#{path}/resume.pdf"
    end
  end

  describe '#move!' do
    before(:each) do
      mock_api_server(load_json('file_move'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.move!('/resume.pdf', client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if path does not start with /' do
      -> { subject.move!('resume2.pdf') }.should raise_error(ArgumentError)
    end

    it 'sends "Groupdocs-Move" header' do
      mock_api_server(load_json('file_move'), :'Groupdocs-Move' => '123')
      subject.stub(id: 123)
      subject.move!('/resume2.pdf')
    end

    it 'returns moved to file' do
      subject.move!('/resume2.pdf').should be_a(GroupDocs::Storage::File)
    end

    it 'appends filename to move to path if it is not passed' do
      path = '/Folder'
      name = File.basename(__FILE__)
      subject.stub(name: name)
      path.should_receive(:<<).with("/#{name}")
      subject.move!(path)
    end
  end

  describe '#rename!' do
    before(:each) do
      subject.path = '/'
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.rename!('resume.pdf', client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses #move! to rename file' do
      subject.should_receive(:move!).with('/resume2.pdf', {})
      subject.rename!('resume2.pdf')
    end
  end

  describe '#copy!' do
    before(:each) do
      mock_api_server(load_json('file_copy'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.copy!('/resume.pdf', client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if path does not start with /' do
      -> { subject.copy!('resume2.pdf') }.should raise_error(ArgumentError)
    end

    it 'sends "Groupdocs-Copy" header' do
      mock_api_server(load_json('file_copy'), :'Groupdocs-Copy' => '123')
      subject.stub(id: 123)
      subject.copy!('/resume2.pdf')
    end

    it 'returns copied to file' do
      subject.copy!('/resume2.pdf').should be_a(GroupDocs::Storage::File)
    end

    it 'appends filename to copy to path if it is not passed' do
      path = '/Folder'
      name = File.basename(__FILE__)
      subject.stub(name: name)
      path.should_receive(:<<).with("/#{name}")
      subject.copy!(path)
    end
  end

  describe '#compress!' do
    before(:each) do
      mock_api_server(load_json('file_compress'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.compress!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns archived file' do
      subject.stub(name: 'resume.pdf')
      subject.compress!.should be_a(GroupDocs::Storage::File)
    end

    it 'creates archive filename as filename + archive type' do
      subject.stub(name: 'resume.pdf')
      subject.compress!.name.should == 'resume.pdf.zip'
    end
  end

  describe '#delete!' do
    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses file guid' do
      mock_api_server(load_json('file_delete'))
      subject.should_receive(:guid).and_return('guid')
      subject.delete!
    end
  end

  describe '#to_document' do
    it 'creates new GroupDocs::Document' do
      subject.to_document.should be_a(GroupDocs::Document)
    end

    it 'passes self as file for GroupDocs::Document' do
      subject.to_document.file.should == subject
    end
  end
end
