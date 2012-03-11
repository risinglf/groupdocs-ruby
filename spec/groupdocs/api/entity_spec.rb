require 'spec_helper'

shared_examples_for GroupDocs::Api::Entity do

  subject do
    if described_class == GroupDocs::Document
      described_class.new(file: GroupDocs::Storage::File.new)
    else
      described_class.new
    end
  end

  it { should be_a(GroupDocs::Api::Entity) }

  describe '#initialize' do
    it 'allows passing options' do
      if described_class == GroupDocs::Document
        object = described_class.new(name: 'Test', file: GroupDocs::Storage::File.new)
      else
        object = described_class.new(name: 'Test')
      end

      object.name.should == 'Test'
    end

    it 'calls passed block for self' do
      if described_class == GroupDocs::Document
        object = described_class.new do |obj|
          obj.name = 'Test'
          obj.file = GroupDocs::Storage::File.new
        end
      else
        object = described_class.new do |obj|
          obj.name = 'Test'
        end
      end

      object.name.should == 'Test'
    end
  end
end
