require 'spec_helper'

describe GroupDocs::Api::Helpers::MIME do
  subject do
    GroupDocs::Signature.new
  end

  describe '#mime_type' do
    it 'returns first MIME type of file' do
      subject.send(:mime_type, __FILE__).should == 'application/ruby'
    end
  end
end
