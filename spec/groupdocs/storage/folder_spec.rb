require 'spec_helper'

describe GroupDocs::Storage::Folder do

  before(:all) do
    GroupDocs.client_id = '07aaaf95f8eb33a4'
    GroupDocs.private_key = '5cb711b3a52ffc5d90ee8a0f79206f5a'
    GroupDocs.api_version = '2.0'
  end

  it_behaves_like 'Api entity'

  describe 'attributes' do
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

  describe '#inspect' do
    let!(:options) { { id: 1, name: 'Test', url: 'http://groupdocs.com/folder/Test' } }

    subject { described_class.new(options) }

    it 'should return object in nice presentation' do
      subject.inspect.should ==
        %(<##{described_class} @id=#{options[:id]} @name="#{options[:name]}" @url="#{options[:url]}">)
    end
  end

  describe '#list!' do
    before(:each) do
      mock_api_server <<-EOF
        {
          "status": "Ok",
          "result":
            {
              "entities":
                [
                  {
                    "id": 1,
                    "dir": true,
                    "created_on": 1330450135,
                    "modified_on": 1330450135
                  },
                  {
                    "id": 2,
                    "dir": false,
                    "created_on": 1330450135,
                    "modified_on": 1330450135
                  }
                ]
            }
        }
      EOF
    end

    it 'should allow passing path' do
      described_class.list!('/test')
    end

    it 'should allow passing options' do
      described_class.list!('/', { page: 1, count: 1 })
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
