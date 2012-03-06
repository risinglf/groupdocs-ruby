require 'spec_helper'

describe GroupDocs::Api::Request do

  subject { described_class.new(method: :GET, path: '/folders') }

  describe 'DEFAULT_HEADERS' do
    subject { described_class::DEFAULT_HEADERS }

    it 'should include "Accept: application/json"' do
      subject.should include({ accept: 'application/json' })
    end

    it 'should include "Content-length: 0"' do
      subject.should include({ content_length: 0 })
    end
  end

  context 'attributes' do
    it { should respond_to(:resource)  }
    it { should respond_to(:response)  }
    it { should respond_to(:response=) }
    it { should respond_to(:options)   }
    it { should respond_to(:options=)  }
  end

  describe '#initialize' do
    it 'should allow passing options' do
      GroupDocs.stub(api_version: nil)
      options = { method: :GET, path: '/folders' }
      request = described_class.new(options)
      request.options.should == options
    end

    it 'should allow passing block to configure options' do
      GroupDocs.stub(api_version: nil)
      described_class.new do |request|
        request[:method] = :GET
        request[:path] = '/folders'
      end.options.should == { method: :GET, path: '/folders' }
    end

    it 'should create resource as API server' do
      GroupDocs.stub(api_server: 'https://dev-api.groupdocs.com')
      subject.resource.should be_a(RestClient::Resource)
    end
  end

  describe '#execute!' do
    before(:each) do
      GroupDocs.stub(private_key: 'private_key')
      subject.options[:method] = :get
      subject.options[:path] = '/folders'
      subject.options[:headers] = {}
      mock_api_server('{"status":"Ok"}')
    end

    it 'should prepend path with version' do
      subject.should_receive(:prepend_version)
      subject.execute!
    end

    it 'should sign url' do
      subject.should_receive(:sign_url)
      subject.execute!
    end

    it 'should prepare request' do
      subject.should_receive(:prepare_request)
      subject.execute!
    end

    it 'should send request' do
      subject.should_receive(:send_request)
      mock_response('{"status": "Ok"}')
      subject.execute!
    end

    it 'should parse response' do
      subject.should_receive(:parse_response)
      subject.execute!
    end
  end
end
