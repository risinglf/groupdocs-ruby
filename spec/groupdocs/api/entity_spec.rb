require 'spec_helper'

shared_examples_for GroupDocs::Api::Entity do

  before(:each) do
    # make sure `id` attribute exists
    described_class.class_eval('attr_accessor :id')
    # add file for GroupDocs::Document because otherwise it raises error
    if described_class == GroupDocs::Document
      described_class.any_instance.stub(file: GroupDocs::Storage::File.new)
    end
  end

  it { should be_a(GroupDocs::Api::Entity) }

  describe '#initialize' do
    it 'allows passing options' do
      described_class.new(id: 1).id.should == 1
    end

    it 'calls passed block for self' do
      described_class.new do |object|
        object.id = 1
      end.id.should == 1
    end
  end
end
