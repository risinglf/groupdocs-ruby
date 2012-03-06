require 'spec_helper'

describe GroupDocs::Storage::File do

  it_behaves_like 'Api entity'

  context 'attributes' do
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

    describe '#created_on=' do
      it 'should modify timestamp to Time object' do
        subject.created_on = 1330450135
        subject.created_on.should be_a(Time)
      end
    end

    describe '#modified_on=' do
      it 'should modify timestamp to Time object' do
        subject.modified_on = 1330450135
        subject.modified_on.should be_a(Time)
      end
    end
  end

  context 'class methods' do
    describe '#upload!' do
      before(:each) do
        mock_api_server(load_json('file_upload'))
      end

      it 'should allow raise error if upload path does not start with /' do
        -> { described_class.upload!('test', 'upload_path') }.should raise_error(ArgumentError)
      end

      it 'should append filename to upload path if it is not passed' do
        upload_path = '/upload_path'
        upload_path.should_receive(:<<).with(File.basename(__FILE__))
        described_class.upload!(__FILE__, upload_path)
      end

      it 'should return GroupDocs::Storage::File object' do
        described_class.upload!(__FILE__).should be_a(GroupDocs::Storage::File)
      end
    end
  end

  context 'instance methods' do
    describe '#download' do
      before(:each) do
        mock_api_server(File.read('spec/support/files/resume.pdf'))
        subject.stub(name: 'resume.pdf')
      end

      let(:path) { Dir.tmpdir }

      it 'should download file to given path' do
        file = stub('file')
        Object::File.should_receive(:open).with("#{path}/resume.pdf", 'w').and_yield(file)
        file.should_receive(:write).with(File.read('spec/support/files/resume.pdf'))
        subject.download!(path)
      end

      it 'should return saved file path' do
        subject.download!(path).should == "#{path}/resume.pdf"
      end
    end

    describe '#move!' do
      it 'should send "Groupdocs-Move" header' do
        mock_api_server(load_json('file_move'), :'Groupdocs-Move' => '123')
        subject.stub(id: 123)
        subject.move!('/resume2.pdf')
      end

      it 'should return moved to file path' do
        mock_api_server(load_json('file_move'))
        moved = subject.move!('/resume2.pdf')
        moved.should be_a(String)
        moved.should == '/resume2.pdf'
      end

      it 'should raise error if path does not start with /' do
        -> { subject.move!('resume2.pdf') }.should raise_error(ArgumentError)
      end

      it 'should append filename to move to path if it is not passed' do
        mock_api_server(load_json('file_move'))
        path = '/Folder'
        name = File.basename(__FILE__)
        subject.stub(name: name)
        path.should_receive(:<<).with(name)
        subject.move!(path)
      end
    end

    describe '#rename!' do
      it 'use #move! to rename file' do
        subject.should_receive(:move!).with('/resume2.pdf').and_return('/resume2.pdf')
        subject.rename!('resume2.pdf')
      end

      it 'should strip leading / symbol from new name' do
        subject.stub(move!: '/resume2.pdf')
        renamed = subject.rename!('resume2.pdf')
        renamed.should be_a(String)
        renamed.should == 'resume2.pdf'
      end
    end

    describe '#copy!' do
      it 'should send "Groupdocs-Copy" header' do
        mock_api_server(load_json('file_copy'), :'Groupdocs-Copy' => '123')
        subject.stub(id: 123)
        subject.copy!('/resume2.pdf')
      end

      it 'should return copied to file ' do
        mock_api_server(load_json('file_copy'))
        copied = subject.copy!('/resume2.pdf')
        copied.should be_a(GroupDocs::Storage::File)
      end

      it 'should raise error if path does not start with /' do
        -> { subject.copy!('resume2.pdf') }.should raise_error(ArgumentError)
      end

      it 'should append filename to copy to path if it is not passed' do
        mock_api_server(load_json('file_copy'))
        path = '/Folder'
        name = File.basename(__FILE__)
        subject.stub(name: name)
        path.should_receive(:<<).with(name)
        subject.copy!(path)
      end
    end

    describe '#compress!' do
      before(:each) do
        mock_api_server(load_json('file_compress'))
      end

      it 'should return archived file ' do
        subject.stub(name: 'resume.pdf')
        subject.compress!(:zip).should be_a(GroupDocs::Storage::File)
      end

      it 'should use archive filename as filename + archive type' do
        subject.stub(name: 'resume.pdf')
        subject.compress!(:zip).name.should == 'resume.pdf.zip'
      end
    end

    describe '#delete!' do
      it 'should use file guid' do
        mock_api_server(load_json('file_delete'))
        subject.should_receive(:guid).and_return('guid')
        subject.delete!
      end
    end

    describe '#inspect' do
      it 'should return object in nice presentation' do
        options = { id: 1, guid: 3, name: 'Test', url: 'http://groupdocs.com/folder/Test' }
        subject = described_class.new(options)
        subject.inspect.should ==
          %(<##{described_class} @id=#{options[:id]} @guid=#{options[:guid]} @name="#{options[:name]}" @url="#{options[:url]}">)
      end
    end
  end
end
