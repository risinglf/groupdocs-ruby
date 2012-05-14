shared_examples_for GroupDocs::Api::Helpers::AccessMode do
  it { should respond_to(:access)  }
  it { should respond_to(:access=) }

  describe '#access' do
    it 'returns converted to human-readable format access mode' do
      subject.should_receive(:parse_access_mode).with(1).and_return(:restricted)
      subject.access = 1
      subject.access.should == :restricted
    end
  end
end
