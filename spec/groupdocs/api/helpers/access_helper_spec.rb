require 'spec_helper'

describe GroupDocs::Api::Helpers::Access do

  subject do
    GroupDocs::Api::Request.new(method: :GET)
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

  describe '#client_id' do
    it 'returns passed to method client ID' do
      subject.options[:access] = { client_id: 'method_client_id' }
      subject.options[:access].should_receive(:[]).with(:client_id).and_return('method_client_id')
      subject.send(:client_id).should == 'method_client_id'
    end

    it 'returns GroupDocs.client_id if access has not been passed to method' do
      subject.options[:access] = {}
      GroupDocs.should_receive(:client_id).and_return('static_client_id')
      subject.send(:client_id).should == 'static_client_id'
    end

    it 'raises error if client ID has not been set' do
      subject.options[:access] = {}
      GroupDocs.client_id = nil
      -> { subject.send(:client_id) }.should raise_error(GroupDocs::NoClientIdError)
    end
  end

  describe '#private_key' do
    it 'returns passed to method private key' do
      subject.options[:access] = { private_key: 'method_private_key' }
      subject.options[:access].should_receive(:[]).with(:private_key).and_return('method_private_key')
      subject.send(:private_key).should == 'method_private_key'
    end

    it 'returns GroupDocs.private_key if access has not been passed to method' do
      subject.options[:access] = {}
      GroupDocs.should_receive(:private_key).and_return('static_private_key')
      subject.send(:private_key).should == 'static_private_key'
    end

    it 'raises error if private key has not been set' do
      subject.options[:access] = {}
      GroupDocs.private_key = nil
      -> { subject.send(:private_key) }.should raise_error(GroupDocs::NoPrivateKeyError)
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
