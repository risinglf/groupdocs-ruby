require 'spec_helper'

describe GroupDocs::Api::Helpers::URL do

  subject { Object.new.extend(described_class) }

  describe '#add_params' do
    it { should respond_to(:add_params) }

    it 'should add parameters to query' do
      mock_api_request('/1/files/2?new_name=invoice.docx')
      subject.options[:path].should_receive(:<<).with("&param=value")
      subject.add_params({ param: 'value' })
    end

    it 'should determine correct URL separator' do
      mock_api_request('/1/files/2')
      subject.should_receive(:separator)
      subject.add_params({ param: 'value' })
    end
  end

  describe '#sign_url' do
    it 'should use defined private key' do
      mock_api_request('/1/files/2?new_name=invoice.docx')
      GroupDocs.should_receive(:private_key).and_return('e98ea443354183fd1fb434047232c687')
      subject.send(:sign_url)
    end

    it 'should add signature to path' do
      path = '/1/files/2?new_name=invoice.docx'
      GroupDocs.stub(private_key: 'e98ea443354183fd1fb434047232c687')
      mock_api_request(path)
      subject.send(:sign_url)
      subject.options[:path].should == "#{path}&signature=gw%2BLupOB3krtliSSM0dvUBSznJY"
    end

    it 'should determine correct URL separator' do
      path = '/1/files/2?new_name=invoice.docx'
      mock_api_request(path)
      subject.should_receive(:separator)
      subject.send(:sign_url)
    end
  end

  describe '#separator' do
    it 'should return ? if URL has no parameters' do
      mock_api_request('/1/files/2')
      subject.send(:separator).should == '?'
    end

    it 'should return & if URL has parameters' do
      mock_api_request('/1/files/2?new_name=invoice.docx')
      subject.send(:separator).should == '&'
    end
  end

  describe '#prepend_version' do
    it 'should not modify URL if API version is not specified' do
      GroupDocs.stub(api_version: nil)
      path = '/1/files/2?new_name=invoice.docx'
      mock_api_request(path)
      subject.send(:prepend_version)
      subject.options[:path].should == path
    end

    it 'should prepend API version number' do
      GroupDocs.stub(api_version: '2.0')
      path = '/1/files/2?new_name=invoice.docx'
      mock_api_request(path)
      subject.send(:prepend_version)
      subject.options[:path].should == "/v2.0#{path}"
    end
  end
end
