require 'spec_helper'

describe GroupDocs::Storage::Folder do

  it_behaves_like 'Api entity'

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
  end

  context 'instance methods' do
    describe '#create!' do
      it 'should return folder' do
        mock_api_server(load_json('folder_create'))
        folder = described_class.create!('/test2')
        folder.should be_a(GroupDocs::Storage::Folder)
      end
    end

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
