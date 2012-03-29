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
    subject.id = 1
  end

  describe '#to_hash' do
    it 'converts object attributes to hash' do
      subject.test = 'Test'
      subject.to_hash.should == { id: 1, test: 'Test' }
    end

    it 'converts attribute to hash if it is object' do
      object = described_class.new(id: 1)
      object.should_receive(:to_hash).and_return({ id: 1 })
      subject.test = object
      subject.to_hash.should == { id: 1, test: { id: 1 } }
    end

    it 'converts attribute to hash if it is array' do
      object1 = described_class.new(id: 1)
      object2 = described_class.new(id: 2)
      object1.should_receive(:to_hash).and_return({ id: 1 })
      object2.should_receive(:to_hash).and_return({ id: 2 })
      subject.test = [object1, object2]
      subject.to_hash.should == { id: 1, test: [{ id: 1 }, { id: 2 }] }
    end
  end

  describe '#inspect' do
    it 'uses accessors instead of instance variables' do
      subject.instance_variable_set(:@test, 1)
      subject.instance_eval('def test; { fire: 1 }.invert[@test] end')
      subject.inspect.should include('@test=:fire')
    end

    it 'uses only not-nil instance variables' do
      subject.instance_variable_set(:@test, nil)
      subject.inspect.should_not include('@test')
    end
  end

  describe '#variable_to_accessor' do
    it 'converts instance variable symbol to accessor method symbol' do
      subject.send(:variable_to_accessor, :@test).should == :test
    end
  end
end
