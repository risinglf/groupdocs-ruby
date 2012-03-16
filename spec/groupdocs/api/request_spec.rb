require 'spec_helper'

describe GroupDocs::Api::Request do

  subject { described_class.new(method: :GET, path: '/folders') }

  context 'attributes' do
    it { should respond_to(:resource)  }
    it { should respond_to(:response)  }
    it { should respond_to(:response=) }
    it { should respond_to(:options)   }
    it { should respond_to(:options=)  }
  end

  describe '#initialize' do
    it 'allows passing options' do
      options = { method: :GET, path: '/folders' }
      request = described_class.new(options)
      request.options.should == options
    end

    it 'allows passing block to configure options' do
      described_class.new do |request|
        request[:access] = { client_id: 'client_id', private_key: 'private_key' }
        request[:method] = :GET
        request[:path] = '/folders'
      end.options.should == { method: :GET, path: '/folders', access: { client_id: 'client_id', private_key: 'private_key' }}
    end

    it 'sets access hash to empty if it was not passed' do
      access = subject.options[:access]
      access.should be_a(Hash)
      access.should be_empty
    end

    it 'creates resource as API server' do
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

    it 'parses path' do
      subject.should_receive(:parse_path)
      subject.execute!
    end

    it 'prepends path with version' do
      subject.should_receive(:prepend_version)
      subject.execute!
    end

    it 'URL encodes path' do
      subject.should_receive(:url_encode_path)
      subject.execute!
    end

    it 'signs url' do
      subject.should_receive(:sign_url)
      subject.execute!
    end

    it 'prepares request' do
      subject.should_receive(:prepare_request)
      subject.execute!
    end

    it 'sends request' do
      subject.should_receive(:send_request)
      mock_response('{"status": "Ok"}')
      subject.execute!
    end

    it 'parses response' do
      subject.should_receive(:parse_response)
      subject.execute!
    end
  end
end
