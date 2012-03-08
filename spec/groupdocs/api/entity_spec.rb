require 'spec_helper'

shared_examples_for 'Api entity' do
  it { should be_a(GroupDocs::Api::Entity) }

  describe '#initialize' do
    it 'allows passing options' do
      object = described_class.new(name: 'Test')
      object.name.should == 'Test'
    end

    it 'calls passed block for self' do
      object = described_class.new do |obj|
        obj.name = 'Test'
      end
      object.name.should == 'Test'
    end
  end

  #describe 'find!' do
  #  it 'allows passing attribute and its value' do
  #    -> { described_class.find_all!(:id, 1) }.should_not raise_error(ArgumentError)
  #  end
  #
  #  it 'calls #find_all! and return its first result' do
  #    found = described_class.new(id: 1)
  #    described_class.should_receive(:find_all!).with(:id, 1).and_return([found])
  #    described_class.find!(:id, 1).should == found
  #  end
  #end
  #
  #describe 'find_all!' do
  #  it 'allows passing attribute and its value' do
  #    -> { described_class.find_all!(:id, 1) }.should_not raise_error(ArgumentError)
  #  end
  #
  #  it 'returns an array' do
  #    haystack = [described_class.new(id: 1), Object.new]
  #    described_class.stub(list!: haystack)
  #    described_class.find_all!(:id, 1).should be_an(Array)
  #  end
  #
  #  it 'includes only self class entities' do
  #    haystack = [described_class.new(name: 'Test'), Object.new, described_class.new(name: 'Test')]
  #    described_class.stub(list!: haystack)
  #    described_class.find_all!(:name, 'Test').each do |found|
  #      found.should be_a(described_class)
  #    end
  #  end
  #
  #  it 'finds by exact match' do
  #    haystack = [described_class.new(name: 'Test'), Object.new]
  #    described_class.stub(list!: haystack)
  #    described_class.find_all!(:name, 'Test').length.should == 1
  #  end
  #
  #  it 'finds by regexp match' do
  #    haystack = [described_class.new(name: 'Test1'), Object.new, described_class.new(name: 'Test2')]
  #    described_class.stub(list!: haystack)
  #    described_class.find_all!(:name, /Test/).length.should == 2
  #  end
  #end
end
