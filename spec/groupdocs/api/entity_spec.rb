require 'spec_helper'

shared_examples_for 'Api entity' do
  it { should be_a(GroupDocs::Api::Entity) }

  describe '#initialize' do
    it 'should allow passing options' do
      options = { id: 1, name: 'Test', url: 'http://groupdocs.com/folder/Test' }
      object = described_class.new(options)
      options.each { |attr, value| object.send(attr).should == value }
    end

    it 'should call passed block for self' do
      object = described_class.new do |obj|
        obj.id = 1
        obj.name = 'Test'
        obj.url = 'http://groupdocs.com/folder/Test'
      end
      object.id.should == 1
      object.name.should == 'Test'
      object.url.should == 'http://groupdocs.com/folder/Test'
    end
  end
end
