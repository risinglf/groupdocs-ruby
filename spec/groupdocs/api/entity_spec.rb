require 'spec_helper'

shared_examples_for GroupDocs::Api::Entity do
  before(:each) do
    # make sure necessary attribute exist
    described_class.class_eval('attr_accessor :id, :test')
    # stub required attributes
    case described_class.name
    when 'GroupDocs::Document'
      described_class.any_instance.stub(file: GroupDocs::Storage::File.new)
    end
  end

  it { should be_a(GroupDocs::Api::Entity) }

  describe '#initialize' do
    it 'allows passing options' do
      object = described_class.new(id: 1, test: 'Test')
      object.id.should == 1
      object.test.should == 'Test'
    end

    it 'calls passed block for self' do
      object = described_class.new do |object|
        object.id = 1
        object.test = 'Test'
      end
      object.id.should == 1
      object.test.should == 'Test'
    end
  end
end


describe GroupDocs::Api::Entity do
  before(:each) do
    # make sure necessary attribute exist
    described_class.class_eval('attr_accessor :id, :test')
  end

  describe '#to_hash' do
    it 'converts object attributes to hash' do
      subject.id = 1
      subject.test = 'Test'
      subject.to_hash.should == { id: 1, test: 'Test' }
    end

    it 'converts attribute to hash if it is object too' do
      subject.id = 1
      subject.test = described_class.new(id: 1)
      subject.to_hash.should == { id: 1, test: { id: 1 } }
    end

    it 'converts attribute to hash if it is array too' do
      subject.id = 1
      subject.test = [described_class.new(id: 1), described_class.new(id: 2)]
      subject.to_hash.should == { id: 1, test: [{ id: 1 }, { id: 2 }] }
    end
  end
end
