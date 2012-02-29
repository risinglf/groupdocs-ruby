require 'spec_helper'

describe GroupDocs::Storage::Folder do

  #it_behaves_like 'Api entity'

  context 'attributes' do
    it { should respond_to(:id)            }
    it { should respond_to(:id=)           }
    it { should respond_to(:size)          }
    it { should respond_to(:size=)         }
    it { should respond_to(:folder_count)  }
    it { should respond_to(:folder_count=) }
    it { should respond_to(:file_count)    }
    it { should respond_to(:file_count=)   }
    it { should respond_to(:created_on)    }
    it { should respond_to(:created_on=)   }
    it { should respond_to(:modified_on)   }
    it { should respond_to(:modified_on=)  }
    it { should respond_to(:url)           }
    it { should respond_to(:url=)          }
    it { should respond_to(:name)          }
    it { should respond_to(:name=)         }
    it { should respond_to(:version)       }
    it { should respond_to(:version=)      }
    it { should respond_to(:type)          }
    it { should respond_to(:type=)         }
    it { should respond_to(:access)        }
    it { should respond_to(:access=)       }

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
    describe '#list!' do
      before(:each) do
        mock_api_server(load_json('folder_list'))
      end

      it 'should allow passing path' do
        -> { described_class.list!('/test') }.should_not raise_error
      end

      it 'should allow passing options' do
        -> { described_class.list!('/', { page: 1, count: 1 }) }.should_not raise_error
      end

      it 'should return array' do
        described_class.list!.should be_an(Array)
      end

      it 'should return empty array if nothing is listed in directory' do
        mock_api_server('{"result": {"entities": []}, "status": "Ok"}')
        described_class.list!.should be_empty
      end

      it 'should determine folders in response' do
        described_class.list!.detect do |entity|
          entity.id == 1
        end.should be_a(GroupDocs::Storage::Folder)
      end

      it 'should determine files in response' do
        described_class.list!.detect do |entity|
          entity.id == 2
        end.should be_a(GroupDocs::Storage::File)
      end
    end

    describe '#create!' do
      before(:each) do
        mock_api_server(load_json('folder_create'))
      end

      it 'should allow passing path' do
        -> { described_class.create!('/Test') }.should_not raise_error(ArgumentError)
      end

      it 'should call list! class method to find new folder' do
        described_class.should_receive(:list!).with(no_args).and_return([described_class.new(id: 1)])
        described_class.create!('/Test')
      end

      it 'should return folder' do
        described_class.stub(list!: [described_class.new(id: 1)])
        folder = described_class.create!('/Test')
        folder.should be_a(GroupDocs::Storage::Folder)
      end
    end
  end

  context 'instance methods' do
    describe '#move!' do
      it 'should send "Groupdocs-Move" header' do
        mock_api_server(load_json('folder_move'), 'Groupdocs-Move' => 'Test1')
        subject.stub(name: 'Test1')
        subject.move!('/Test2')
      end

      it 'should return moved to folder path' do
        mock_api_server(load_json('folder_move'))
        moved = subject.move!('/Test2')
        moved.should be_a(String)
        moved.should == '/Test2'
      end

      it 'should raise error if path does not start with /' do
        -> { subject.move!('Test2') }.should raise_error(ArgumentError)
      end
    end

    describe '#rename!' do
      it 'use #move! to rename directory' do
        subject.should_receive(:move!).with('/Test2').and_return('/Test2')
        subject.rename!('Test2')
      end

      it 'should strip leading / symbol from new name' do
        subject.stub(move!: '/Test2')
        renamed = subject.rename!('Test2')
        renamed.should be_a(String)
        renamed.should == 'Test2'
      end
    end

    describe '#list!' do
      before(:each) do
        mock_api_server(load_json('folder_list'))
      end

      subject { described_class.new(name: 'Test1') }

      it 'should allow passing options' do
        -> { subject.list!(page: 1, count: 1) }.should_not raise_error
      end

      it 'should call list! class method and pass parameters to it' do
        described_class.should_receive(:list!).with('/Test1', { page: 1, count: 1})
        subject.list!(page: 1, count: 1)
      end
    end

    describe '#inspect' do
      it 'should return object in nice presentation' do
        options = { id: 1, name: 'Test', url: 'http://groupdocs.com/folder/Test' }
        subject = described_class.new(options)
        subject.inspect.should ==
          %(<##{described_class} @id=#{options[:id]} @name="#{options[:name]}" @url="#{options[:url]}">)
      end
    end
  end
end
