require 'spec_helper'

describe GroupDocs::Storage::File do

  before(:all) do
    GroupDocs.client_id = '07aaaf95f8eb33a4'
    GroupDocs.private_key = '5cb711b3a52ffc5d90ee8a0f79206f5a'
    GroupDocs.api_version = '2.0'
  end

  #it_behaves_like 'Api entity'

  describe 'attributes' do
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

  describe '#inspect' do
    let!(:options) { { id: 1, guid: 3, name: 'Test', url: 'http://groupdocs.com/folder/Test' } }

    subject { described_class.new(options) }

    it 'should return object in nice presentation' do
      subject.inspect.should ==
        %(<##{described_class} @id=#{options[:id]} @guid=#{options[:guid]} @name="#{options[:name]}" @url="#{options[:url]}">)
    end
  end
end
