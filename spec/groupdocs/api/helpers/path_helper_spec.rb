require 'spec_helper'

describe GroupDocs::Api::Helpers::Path do

  describe '.verify_starts_with_root' do
    it 'does not raise error if path starts with /' do
      -> { described_class.verify_starts_with_root('/Test') }.should_not raise_error(ArgumentError)
    end

    it 'raises error if path does not start with /' do
      -> { described_class.verify_starts_with_root('Test') }.should raise_error(ArgumentError)
    end
  end

  describe '.append_file_name' do
    it 'does not change path if filename is present' do
      path = '/upload_path/test.pdf'
      described_class.append_file_name(path, __FILE__)
      path.should == '/upload_path/test.pdf'
    end

    it 'appends filename to path if it is not passed' do
      path = '/upload_path'
      described_class.append_file_name(path, __FILE__)
      path.should == "/upload_path/#{File.basename(__FILE__)}"
    end
  end
end
