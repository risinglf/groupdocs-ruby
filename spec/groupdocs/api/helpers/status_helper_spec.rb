require 'spec_helper'

describe GroupDocs::Api::Helpers::Status do

  subject do
    Object.extend(described_class)
  end

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

  describe '#parse_status' do
    it 'raise error if status is unknown' do
      -> { subject.send(:parse_status, 8)        }.should raise_error(ArgumentError)
      -> { subject.send(:parse_status, :unknown) }.should raise_error(ArgumentError)
    end

    it 'returns :draft if passed status is -1' do
      subject.send(:parse_status, -1).should == :draft
    end

    it 'returns :pending if passed status is 0' do
      subject.send(:parse_status, 0).should == :pending
    end

    it 'returns :scheduled if passed status is 1' do
      subject.send(:parse_status, 1).should == :scheduled
    end

    it 'returns :in_progress if passed status is 2' do
      subject.send(:parse_status, 2).should == :in_progress
    end

    it 'returns :completed if passed status is 3' do
      subject.send(:parse_status, 3).should == :completed
    end

    it 'returns :postponed if passed status is 4' do
      subject.send(:parse_status, 4).should == :postponed
    end

    it 'returns :archived if passed status is 5' do
      subject.send(:parse_status, 5).should == :archived
    end

    it 'returns -1 if passed status is :draft' do
      subject.send(:parse_status, :draft).should == -1
    end

    it 'returns 0 if passed status is :pending' do
      subject.send(:parse_status, :pending).should == 0
    end

    it 'returns 1 if passed status is :scheduled' do
      subject.send(:parse_status, :scheduled).should == 1
    end

    it 'returns 2 if passed status is :in_progress' do
      subject.send(:parse_status, :in_progress).should == 2
    end

    it 'returns 3 if passed status is :completed' do
      subject.send(:parse_status, :completed).should == 3
    end

    it 'returns 4 if passed status is :postponed' do
      subject.send(:parse_status, :postponed).should == 4
    end

    it 'returns 5 if passed status is :archived' do
      subject.send(:parse_status, :archived).should == 5
    end
  end
end
