require 'spec_helper'

describe GroupDocs::Api::Helpers::URL do

  subject { Object.new.extend(described_class) }

  describe '#sign_url' do
    before(:all) do
      GroupDocs.private_key = 'e98ea443354183fd1fb434047232c687'
    end

    after(:all) do
      GroupDocs.private_key = nil
      GroupDocs.api_version = nil
    end

    let!(:url)       { '/1/files/2?new_name=invoice.docx' }
    let!(:signature) { 'gw%2BLupOB3krtliSSM0dvUBSznJY' }

    it 'should use defined private key' do
      GroupDocs.should_receive(:private_key).and_return('e98ea443354183fd1fb434047232c687')
      subject.sign_url(url)
    end

    it 'should sign URL' do
      subject.sign_url(url).should == "#{url}&signature=#{signature}"
    end
  end

  describe '#separator' do
    it 'should return ? if URL has no parameters' do
      url = '/1/files/2'
      subject.separator(url).should == '?'
    end

    it 'should return & if URL has parameters' do
      url = '/1/files/2?new_name=invoice.docx'
      subject.separator(url).should == '&'
    end
  end

  describe '#prepend_slash' do
    it 'should add leading slash to URL if it is missed' do
      url = '1/files/2?new_name=invoice.docx'
      subject.prepend_slash(url).should == "/#{url}"
    end

    it 'should not modify URL if leading slash is not missed' do
      url = '/1/files/2?new_name=invoice.docx'
      subject.prepend_slash(url).should == url
    end
  end

  describe '#prepend_version' do
    it 'should not modify URL if API version is not specified' do
      url = '/1/files/2?new_name=invoice.docx'
      subject.prepend_version(url).should == url
    end

    it 'should prepend API version number' do
      GroupDocs.api_version = '2.0'
      url = '/1/files/2?new_name=invoice.docx'
      subject.prepend_version(url).should == "/v#{GroupDocs.api_version}#{url}"
    end
  end
end
