require 'spec_helper'

shared_examples_for GroupDocs::Api::Entity do

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
end
