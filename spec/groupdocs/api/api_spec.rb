require 'spec_helper'

describe GroupDocs::Api::Request do

  before(:all) do
    GroupDocs.private_key = 'e98ea443354183fd1fb434047232c687'
  end

  after(:each) do
    GroupDocs.api_version = nil
  end

  describe '#execute' do
    let!(:signature) { 'gw%2BLupOB3krtliSSM0dvUBSznJY' }

    it 'should prepend with API version if necessary' do
      GroupDocs.api_version = '2.0'
      path = '/jobs'
      described_class.should_receive(:prepend_version).with(path).and_return("/v#{GroupDocs.api_version}#{path}")
      described_class.new(:GET, path)
    end

    it 'should sign URL' do
      path = '/1/files/2?new_name=invoice.docx'
      subject.should_receive(:sign_url).with(path).and_return(signature)
      subject.execute(:GET, path)
    end

    it 'should prepare HTTP request' do
      path = '/1/files/2?new_name=invoice.docx'
      signed_url = "#{path}&signature=#{signature}"
      subject.should_receive(:prepare_request).with(:GET, signed_url, {}).and_return(Net::HTTP::Get.new(path))
      subject.execute(:GET, path)
    end

    it 'should return HTTP request' do
      path = '/1/files/2?new_name=invoice.docx'
      subject.execute(:GET, path).should be_a(Net::HTTPResponse)
    end
  end
end
