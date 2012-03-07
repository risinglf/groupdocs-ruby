require 'spec_helper'

describe GroupDocs::Api::Helpers::URL do

  subject do
    GroupDocs::Api::Request.new(path: '/1/files/2?new_name=invoice.docx')
  end

  describe '#add_params' do
    it 'adds parameters to query' do
      subject.options[:path].should_receive(:<<).with('&param=value')
      subject.add_params({ param: 'value' })
    end

    it 'determines correct URL separator' do
      subject.options[:path] = '/1/files/2'
      subject.should_receive(:separator)
      subject.add_params({ param: 'value' })
    end
  end

  describe '#sign_url' do
    it 'uses defined private key' do
      GroupDocs.should_receive(:private_key).and_return('e98ea443354183fd1fb434047232c687')
      subject.send(:sign_url)
    end

    it 'adds signature to path' do
      GroupDocs.stub(private_key: 'e98ea443354183fd1fb434047232c687')
      GroupDocs.stub(api_version: nil)
      subject.send(:sign_url)
      subject.options[:path].should == '/1/files/2?new_name=invoice.docx&signature=gw%2BLupOB3krtliSSM0dvUBSznJY'
    end

    it 'determines correct URL separator' do
      subject.should_receive(:separator)
      subject.send(:sign_url)
    end
  end

  describe '#separator' do
    it 'returns ? if URL has no parameters' do
      subject.options[:path] = '/1/files/2'
      subject.send(:separator).should == '?'
    end

    it 'returns & if URL has parameters' do
      subject.send(:separator).should == '&'
    end
  end

  describe '#prepend_version' do
    it 'does not modify URL if API version is not specified' do
      GroupDocs.stub(api_version: nil)
      subject.options.should_not_receive(:[]=).with(:path, '/v2.0/1/files/2?new_name=invoice.docx')
      subject.send(:prepend_version)
    end

    it 'prepends API version number' do
      GroupDocs.stub(api_version: '2.0')
      path = '/1/files/2?new_name=invoice.docx'
      subject = GroupDocs::Api::Request.new(path: path)
      subject.options.should_receive(:[]=).with(:path, "/v2.0#{path}").and_return("/v2.0#{path}")
      subject.send(:prepend_version)
    end
  end
end
