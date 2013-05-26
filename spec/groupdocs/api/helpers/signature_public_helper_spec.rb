require 'spec_helper'

describe GroupDocs::Api::Helpers::SignaturePublic do
  subject do
    GroupDocs::Signature::Envelope.new
  end

  describe '#client_id' do
    it 'returns "public" if true is passed' do
      subject.send(:client_id, true).should == 'public'
    end

    it 'returns "{{client_id}}" if false is passed' do
      subject.send(:client_id, false).should == '{{client_id}}'
    end

    it 'returns "{{client_id}}" if nil is passed' do
      subject.send(:client_id, false).should == '{{client_id}}'
    end
  end
end
