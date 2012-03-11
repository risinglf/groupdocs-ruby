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

  let(:attr) do
    attr = described_class.instance_methods.detect do |m|
      m != :file= && m =~ /.+=/
    end
    attr.to_s.sub(/=/, '')
  end

  describe '#initialize' do
    it 'allows passing options' do
      if described_class == GroupDocs::Document
        object = described_class.new(:file => GroupDocs::Storage::File.new, :"#{attr}" => 'Test', )
      else
        object = described_class.new(:"#{attr}" => 'Test')
      end

      object.send(attr).should == 'Test'
    end

    it 'calls passed block for self' do
      if described_class == GroupDocs::Document
        object = described_class.new do |obj|
          obj.file = GroupDocs::Storage::File.new
          obj.send(:"#{attr}=", 'Test')
        end
      else
        object = described_class.new do |obj|
          obj.send(:"#{attr}=", 'Test')
        end
      end

      object.send(attr).should == 'Test'
    end
  end
end
