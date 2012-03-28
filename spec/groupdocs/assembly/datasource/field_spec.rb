require 'spec_helper'

describe GroupDocs::Assembly::DataSource::Field do

  it_behaves_like GroupDocs::Api::Entity

  describe 'TYPES' do
    it 'contains hash of field types' do
      described_class::TYPES.should == {
        text:   0,
        binary: 1,
      }
    end
  end

  it { should respond_to(:field)   }
  it { should respond_to(:field=)  }
  it { should respond_to(:type)    }
  it { should respond_to(:type=)   }
  it { should respond_to(:values)  }
  it { should respond_to(:values=) }

  describe '#type=' do
    it 'saves type in machine readable format if symbol is passed' do
      subject.type = :binary
      subject.instance_variable_get(:@type).should == 1
    end

    it 'does nothing if parameter is not symbol' do
      subject.type = 1
      subject.instance_variable_get(:@type).should == 1
    end
  end

  describe '#type' do
    it 'returns type in human-readable format' do
      subject.type = 1
      subject.type.should == :binary
    end
  end
end
