require 'spec_helper'

describe GroupDocs::Api::Helpers::REST do

  subject do
    GroupDocs::Api::Request.new(method: :GET)
  end

  describe 'DEFAULT_HEADERS' do
    subject { described_class::DEFAULT_HEADERS }

    it 'includes "Accept: application/json"' do
      subject.should include({ accept: 'application/json' })
    end

    it 'includes "Content-length: 0"' do
      subject.should include({ content_length: 0 })
    end
  end

  describe '#prepare_request' do
    it 'merges default headers with passed' do
      subject.options[:headers] = { keep_alive: 300 }
      merged_headers = described_class::DEFAULT_HEADERS.merge({ keep_alive: 300 })
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:headers] }.to(merged_headers)
    end

    it 'uses default headers when not passed' do
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:headers] }.to(described_class::DEFAULT_HEADERS)
    end

    it 'downcases HTTP method' do
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:method] }.to(:get)
    end

    it 'coverts request body to JSON' do
      subject.options[:method] = :POST
      subject.options[:request_body] = { body: 'test' }
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:request_body] }.to('{"body":"test"}')
    end

    it 'calculates and sets Content-length' do
      subject.options[:method] = :POST
      subject.options[:headers] = {}
      subject.options[:request_body] = { body: 'test' }
      lambda do
        subject.send(:prepare_request)
      end.should change { subject.options[:headers][:content_length] }.to(15)
    end
  end

  describe '#send_request' do
    %w(GET DOWNLOAD POST PUT DELETE).each do |method|
      it "sends HTTP #{method} request" do
        mock_api_server('{"status": "Ok"}')
        method = method.downcase.to_sym
        subject.options[:method] = method
        subject.options[:path] = '/folders'
        subject.options[:headers] = {}
        subject.send(:send_request)
      end
    end

    it 'raises error if incorrect method has been passed' do
      subject.options[:method] = :TEST
      -> { subject.send(:send_request) }.should raise_error(GroupDocs::Errors::UnsupportedMethodError)
    end

    it 'saves response' do
      mock_api_server('{"status": "Ok"}')
      subject.options[:method] = :get
      subject.options[:path] = '/folders'
      subject.options[:headers] = {}
      lambda do
        subject.send(:send_request)
      end.should change(subject, :response).to('{"status": "Ok"}')
    end
  end

  describe '#parse_response' do
    it 'does not parse body if request method was DOWNLOAD' do
      subject.options[:method] = :download
      JSON.should_not_receive(:parse)
      lambda do
        subject.send(:parse_response)
      end.should_not change(subject, :response)
    end

    it 'returns JSON and save it to response' do
      mock_response('{"status": "Ok"}')
      JSON.should_receive(:parse).with(subject.response, symbolize_names: true).and_return({ status: 'Ok' })
      subject.send(:parse_response).should == { status: 'Ok' }
    end

    it 'raises error if response status is not "Ok"' do
      unparsed_json = '{"status": "Failed", "error_message": "The source path is not found."}'
      parsed_json   = { status: "Failed", error_message: "The source path is not found." }
      mock_response(unparsed_json)
      subject.should_receive(:raise_bad_request_error).with(parsed_json)
      subject.send(:parse_response)
    end
  end

  describe '#raise_bad_request_error' do
    let(:json) do
      { status: 'Failed', error_message: 'The source path is not found.' }
    end

    it 'raises error' do
      lambda do
        subject.send(:raise_bad_request_error, json)
      end.should raise_error(GroupDocs::Errors::BadResponseError)
    end

    it 'shows "Bad response!" message' do
      lambda do
        subject.send(:raise_bad_request_error, json)
      end.should raise_error(message = /Bad response!/)
    end

    it 'contains information about request method' do
      subject.options[:method] = :get
      lambda do
        subject.send(:raise_bad_request_error, json)
      end.should raise_error(message = /Request method: GET/)
    end

    it 'contains information about request URL' do
      subject.options[:path] = '/folders'
      lambda do
        subject.send(:raise_bad_request_error, json)
      end.should raise_error(message = %r(Request URL: https?://(.+)/folders))
    end

    it 'contains information about request body' do
      subject.options[:request_body] = '{"test": 123}'
      lambda do
        subject.send(:raise_bad_request_error, json)
      end.should raise_error(message = /Request body: {"test": 123}/)
    end

    it 'contains information about response status' do
      lambda do
        subject.send(:raise_bad_request_error, json)
      end.should raise_error(message = /Status: Failed/)
    end

    it 'contains information about error message' do
      lambda do
        subject.send(:raise_bad_request_error, json)
      end.should raise_error(message = /Error message: The source path is not found./)
    end

    it 'contains information about response body' do
      mock_response('{"status": "Failed", "error_message": "The source path is not found."}')
      lambda do
        subject.send(:raise_bad_request_error, json)
      end.should raise_error(message = /Response body: {"status": "Failed", "error_message": "The source path is not found."}/)
    end
  end
end
