require 'spec_helper'

describe GroupDocs::Storage do
  describe '#info!' do
    before(:each) do
      mock_api_server(load_json('storage_info'))
    end

    it 'should return a hash of information' do
      described_class.info!.should be_an(Hash)
    end

    it 'should convert total space to MB' do
      described_class.info![:total_space].should == "1024 MB"
    end

    it 'should convert available space to MB' do
      described_class.info![:available_space].should == "1020 MB"
    end
  end
end
