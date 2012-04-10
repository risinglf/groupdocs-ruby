shared_examples_for GroupDocs::Api::Entity do
  before(:each) do
    # make sure necessary attribute exist
    described_class.class_eval('attr_accessor :id, :test')
    # stub required attributes
    case described_class.name
    when 'GroupDocs::Document'
      described_class.any_instance.stub(file: GroupDocs::Storage::File.new)
    when 'GroupDocs::Document::Annotation'
      GroupDocs::Document.any_instance.stub(file: GroupDocs::Storage::File.new)
      described_class.any_instance.stub(document: GroupDocs::Document.new)
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