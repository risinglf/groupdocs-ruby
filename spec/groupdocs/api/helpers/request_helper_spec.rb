require 'spec_helper'

describe GroupDocs::Api::Helpers::Request do

  subject { Object.new.extend(described_class) }

  describe '#send_request' do
    it 'should return HTTP response object' do
      request = Net::HTTP::Get.new('/')
      subject.send(:send_request, request).should be_a(Net::HTTPResponse)
    end
  end

  describe '#prepare_request' do
    %w(GET POST PUT DELETE).each do |method|
      it "should return HTTP #{method} request object" do
        request = subject.send(:prepare_request, method.to_sym, '/')
        request.should be_a(Net::HTTP.const_get(method.capitalize))
      end
    end

    it 'should raise error if unsupported method is passed' do
      -> { subject.send(:prepare_request, 'TRACE', '/') }.should raise_error(ArgumentError)
    end
  end
end
