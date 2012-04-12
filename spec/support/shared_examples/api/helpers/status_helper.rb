shared_examples_for GroupDocs::Api::Helpers::Status do
  it { should respond_to(:status)  }
  it { should respond_to(:status=) }

  describe '#status' do
    it 'returns converted to human-readable format status' do
      subject.should_receive(:parse_status).with(0).and_return(:pending)
      subject.status = 0
      subject.status.should == :pending
    end
  end
end
