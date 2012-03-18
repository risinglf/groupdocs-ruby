require 'spec_helper'

describe GroupDocs::Api::Helpers::Status do
  describe 'STATUSES' do
    it 'contains hash of entity statuses' do
      described_class::STATUSES.should == {
        draft:      -1,
        pending:     0,
        scheduled:   1,
        in_progress: 2,
        completed:   3,
        postponed:   4,
        archived:    5,
      }
    end
  end
end

shared_examples_for GroupDocs::Api::Helpers::Status do

  it { should respond_to(:status)  }
  it { should respond_to(:status=) }

  describe '#status=' do
    it 'saves status to human-readable format' do
      subject.status = -1
      subject.status.should == :draft
    end
  end
end
