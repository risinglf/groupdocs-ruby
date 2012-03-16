require 'spec_helper'

describe GroupDocs::Storage::Folder do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Sugar::Lookup

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
      it 'modifies timestamp to Time object' do
        subject.created_on = 1330450135
        subject.created_on.should be_a(Time)
      end
    end

    describe '#modified_on=' do
      it 'modifies timestamp to Time object' do
        subject.modified_on = 1330450135
        subject.modified_on.should be_a(Time)
      end
    end
  end

  context 'class methods' do
    describe '#create!' do
      before(:each) do
        mock_api_server(load_json('folder_create'))
      end

      it 'accepts access credentials hash' do
        lambda do
          described_class.create!('/Test', client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'raises error if path does not start with /' do
        -> { described_class.create!('Test') }.should raise_error(ArgumentError)
      end

      it 'calls find! class method to find new folder' do
        described_class.should_receive(:find!).with(:id, 1, {}).and_return([described_class.new(id: 1)])
        described_class.create!('/Test')
      end

      it 'returns GroupDocs::Storage::Folder object' do
        described_class.stub(find!: described_class.new(id: 1))
        folder = described_class.create!('/Test')
        folder.should be_a(GroupDocs::Storage::Folder)
      end
    end

    describe '#list!' do
      before(:each) do
        mock_api_server(load_json('folder_list'))
      end

      it 'accepts access credentials hash' do
        lambda do
          described_class.list!('/', {}, client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'allows passing path' do
        -> { described_class.list!('/test') }.should_not raise_error(ArgumentError)
      end

      it 'allows passing options' do
        -> { described_class.list!('/', { page: 1, count: 1 }) }.should_not raise_error(ArgumentError)
      end

      it 'returns array' do
        described_class.list!.should be_an(Array)
      end

      it 'returns empty array if nothing is listed in directory' do
        mock_api_server('{"result": {"entities": []}, "status": "Ok"}')
        described_class.list!.should be_empty
      end

      it 'determines folders in response' do
        described_class.list!.detect do |entity|
          entity.id == 1
        end.should be_a(GroupDocs::Storage::Folder)
      end

      it 'determines files in response' do
        described_class.list!.detect do |entity|
          entity.id == 2
        end.should be_a(GroupDocs::Storage::File)
      end
    end
  end

  context 'instance methods' do
    describe '#move!' do
      it 'accepts access credentials hash' do
        lambda do
          subject.move!('/Test', client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'raises error if path does not start with /' do
        -> { subject.move!('Test2') }.should raise_error(ArgumentError)
      end

      it 'sends "Groupdocs-Move" header' do
        mock_api_server(load_json('folder_move'), :'Groupdocs-Move' => 'Test1')
        subject.stub(name: 'Test1')
        subject.move!('/Test2')
      end

      it 'returns moved to folder path' do
        mock_api_server(load_json('folder_move'))
        moved = subject.move!('/Test2')
        moved.should be_a(String)
        moved.should == '/Test2'
      end
    end

    describe '#rename!' do
      it 'accepts access credentials hash' do
        lambda do
          subject.rename!('Test2', client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'uses #move! to rename directory' do
        subject.should_receive(:move!).with('/Test2', {}).and_return('/Test2')
        subject.rename!('Test2')
      end

      it 'strips leading / symbol from new name' do
        subject.stub(move!: '/Test2')
        renamed = subject.rename!('Test2')
        renamed.should be_a(String)
        renamed.should == 'Test2'
      end
    end

    describe '#copy!' do
      it 'accepts access credentials hash' do
        lambda do
          subject.copy!('/Test2', client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'raises error if path does not start with /' do
        -> { subject.copy!('Test2') }.should raise_error(ArgumentError)
      end

      it 'sends "Groupdocs-Copy" header' do
        mock_api_server(load_json('folder_move'), :'Groupdocs-Copy' => 'Test1')
        subject.stub(name: 'Test1')
        subject.copy!('/Test2')
      end

      it 'returns moved to folder path' do
        mock_api_server(load_json('folder_move'))
        moved = subject.copy!('/Test2')
        moved.should be_a(String)
        moved.should == '/Test2'
      end
    end

    describe '#list!' do
      before(:each) do
        mock_api_server(load_json('folder_list'))
        subject.stub(name: 'Test1')
      end

      it 'accepts access credentials hash' do
        lambda do
          subject.list!({}, client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'allows passing options' do
        -> { subject.list!(page: 1, count: 1) }.should_not raise_error(ArgumentError)
      end

      it 'calls list! class method and pass parameters to it' do
        described_class.should_receive(:list!).with('/Test1', { page: 1, count: 1}, {})
        subject.list!(page: 1, count: 1)
      end
    end

    describe '#create!' do
      before(:each) do
        mock_api_server(load_json('folder_create'))
      end

      it 'accepts access credentials hash' do
        lambda do
          subject.create!(client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'calls create! class method and pass parameters to it' do
        subject = described_class.new(name: 'Test1')
        described_class.should_receive(:create!).with('/Test1', {})
        subject.create!
      end
    end

    describe '#delete!' do
      before(:each) do
        mock_api_server(load_json('folder_delete'))
      end

      it 'accepts access credentials hash' do
        lambda do
          subject.delete!(client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'determines path by name' do
        subject.should_receive(:name).and_return('Test1')
        subject.delete!
      end
    end

    describe '#sharers!' do
      before(:each) do
        mock_api_server(load_json('folder_sharers_get'))
      end

      it 'accepts access credentials hash' do
        lambda do
          subject.sharers!(client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'returns an array of GroupDocs::User objects' do
        users = subject.sharers!
        users.should be_an(Array)
        users.each do |user|
          user.should be_a(GroupDocs::User)
        end
      end
    end

    describe '#sharers_set!' do
      before(:each) do
        mock_api_server(load_json('folder_sharers_set'))
      end

      it 'accepts access credentials hash' do
        lambda do
          subject.sharers_set!(%w(test1@email.com), client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'accepts emails array' do
        lambda do
          subject.sharers_set!(%w(test1@email.com test2@email.com))
        end.should_not raise_error(ArgumentError)
      end

      it 'clears sharers if empty array is passed' do
        subject.should_receive(:sharers_clear!)
        subject.sharers_set!([])
      end

      it 'clears sharers if nil is passed' do
        subject.should_receive(:sharers_clear!)
        subject.sharers_set!(nil)
      end
    end

    describe '#sharers_clear!' do
      before(:each) do
        mock_api_server(load_json('folder_sharers_remove'))
      end

      it 'accepts access credentials hash' do
        lambda do
          subject.sharers_clear!(client_id: 'client_id', private_key: 'private_key')
        end.should_not raise_error(ArgumentError)
      end

      it 'clears sharers list and returns nil' do
        subject.sharers_clear!.should be_nil
      end
    end
  end
end
