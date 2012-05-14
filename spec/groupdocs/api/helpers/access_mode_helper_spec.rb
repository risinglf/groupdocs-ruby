require 'spec_helper'

describe GroupDocs::Api::Helpers::AccessMode do

  subject do
    GroupDocs::Storage::Folder.new
  end

  describe 'MODES' do
    it 'contains hash of access modes' do
      described_class::MODES.should == {
        private:    0,
        restricted: 1,
        public:     2,
      }
    end
  end

  describe '#parse_access_mode' do
    it 'raise error if mode is unknown' do
      -> { subject.send(:parse_access_mode, 3)        }.should raise_error(ArgumentError)
      -> { subject.send(:parse_access_mode, :unknown) }.should raise_error(ArgumentError)
    end

    it 'returns :private if passed mode is 0' do
      subject.send(:parse_access_mode, 0).should == :private
    end

    it 'returns :restricted if passed mode is 1' do
      subject.send(:parse_access_mode, 1).should == :restricted
    end

    it 'returns :public if passed mode is 2' do
      subject.send(:parse_access_mode, 2).should == :public
    end

    it 'returns 0 if passed mode is :private' do
      subject.send(:parse_access_mode, :private).should == 0
    end

    it 'returns 1 if passed mode is :restricted' do
      subject.send(:parse_access_mode, :restricted).should == 1
    end

    it 'returns 2 if passed mode is :public' do
      subject.send(:parse_access_mode, :public).should == 2
    end
  end
end
