require 'spec_helper'

describe GroupDocs::Api::Request do

  subject { described_class.new(method: :GET, path: '/jobs') }

  describe 'DEFAULT_HEADERS' do
    subject { described_class::DEFAULT_HEADERS }

    it 'should include "Accept: application/json"' do
      subject.should include({ accept: 'application/json' })
    end
  end

  describe '#initialize' do
    it 'should allow passing options' do
      options = { method: :GET, path: '/jobs' }
      request = described_class.new(options)
      request.options.should == options
    end

    it 'should allow passing block to configure options' do
      described_class.new do |request|
        request[:method] = :GET
        request[:path] = '/jobs'
      end.options.should == { method: :GET, path: '/jobs' }
    end

    it 'should create resource as API server' do
      GroupDocs.should_receive(:api_server).and_return('https://dev-api.groupdocs.com')
      subject.resource.should be_a(RestClient::Resource)
    end
  end

  describe '#execute' do
    it { should respond_to(:execute) }

    it 'should sign url' do
      mock_resource(:GET)
      subject.should_receive(:sign_url)
      subject.execute
    end

    it 'should send request' do
      GroupDocs.should_receive(:private_key).and_return('private_key')
      subject.should_receive(:send_request)
      subject.execute
    end
  end

  describe '#send_request' do
    it 'should merge default headers with passed' do
      mock_resource(:GET)
      subject.options[:headers] = { keep_alive: 300 }
      merged_headers = described_class::DEFAULT_HEADERS.merge({ keep_alive: 300 })
      lambda do
        subject.send(:send_request)
      end.should change { subject.options[:headers] }.from({ keep_alive: 300 }).to(merged_headers)
    end

    it 'should use default headers when not passed' do
      mock_resource(:GET)
      lambda do
        subject.send(:send_request)
      end.should change { subject.options[:headers] }.from(nil).to(described_class::DEFAULT_HEADERS)
    end

    it 'should downcase HTTP method' do
      mock_resource(:GET)
      lambda do
        subject.send(:send_request)
      end.should change { subject.options[:method] }.from(:GET).to(:get)
    end

    it 'should covert request body to JSON' do
      mock_resource(:POST)
      subject.options[:method] = :POST
      subject.options[:request_body] = { body: 'test' }
      lambda do
        subject.send(:send_request)
      end.should change { subject.options[:request_body] }.from({ body: 'test' }).to('{"body":"test"}')
    end

    %w(GET POST PUT DELETE).each do |method|
      it "should send HTTP #{method} request" do
        mock_resource(method.to_sym)
        subject.options[:method] = method.to_sym
        subject.send(:send_request)
      end
    end

    it 'should raise error if incorrect method has been passed' do
      subject.options[:method] = :TEST
      -> { subject.send(:send_request) }.should raise_error(GroupDocs::Errors::UnsupportedMethodError)
    end
  end
end
