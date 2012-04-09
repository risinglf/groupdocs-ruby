shared_examples_for GroupDocs::Api::Helpers::Status do
  it { should respond_to(:status)  }
  it { should respond_to(:status=) }

  describe '#status=' do
    it 'saves status to human-readable format' do
      subject.should_receive(:parse_status).with(0)
      subject.status = 0
    end
  end
end
