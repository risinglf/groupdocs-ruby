require 'spec_helper'

shared_examples_for GroupDocs::Api::Sugar::Lookup do

  let(:found) do
    if described_class == GroupDocs::Document
      described_class.new(id: 1, file: GroupDocs::Storage::File.new)
    else
      described_class.new(id: 1)
    end
  end

  describe 'find!' do
    it 'calls #find_all! and return its first result' do
      described_class.should_receive(:find_all!).with(:id, 1, {}).and_return([found])
      described_class.find!(:id, 1).should == found
    end
  end

  describe 'find_all!' do
    before(:each) do
      folder1 = stub(list!: [], id: 1, name: 'Test')
      folder2 = stub(list!: [folder1], id: 2, name: 'Test2')
      described_class.stub(all!: [folder1, folder2])
    end

    it 'raises error if class does not implement #all!' do
      described_class.stub(:respond_to?).with(:all!).and_return(false)
      lambda do
        described_class.find_all!(:id, 1)
      end.should raise_error(NoMethodError, "#{described_class}#all! is not implemented - aborting.")
    end

    it 'allows passing attribute and its value' do
      -> { described_class.find_all!(:id, 1) }.should_not raise_error(ArgumentError)
    end

    it 'calls #all! and search within it' do
      described_class.should_receive(:all!).and_return([found])
      described_class.find_all!(:name, 'Test')
    end

    it 'returns an array' do
      described_class.find_all!(:id, 1).should be_an(Array)
    end

    it 'finds by exact match' do
      described_class.find_all!(:name, 'Test').length.should == 1
    end

    it 'finds by regexp match' do
      described_class.find_all!(:name, /Test/).length.should == 2
    end
  end
end
