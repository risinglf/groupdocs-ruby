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

  context 'instance methods' do
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
