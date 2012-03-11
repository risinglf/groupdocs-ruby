require 'spec_helper'

describe GroupDocs::Document do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Sugar::Lookup

  subject do
    file = GroupDocs::Storage::File.new
    described_class.new(file: file)
  end

  describe '#initialize' do
    it 'raises error if file is not specified' do
      -> { described_class.new }.should raise_error(ArgumentError)
    end

    it 'raises error if file is not an instance of GroupDocs::Storage::File' do
      -> { described_class.new(file: '') }.should raise_error(ArgumentError)
    end
  end

  context 'attributes' do
    it { should respond_to(:file)  }
    it { should respond_to(:file=) }
  end

  context 'instance methods' do
    describe '#access_mode!' do
      it 'returns access mode in human readable presentation' do
        mock_api_server('{"status": "Ok", "result": {"access": 0 }}')
        subject.should_receive(:parse_access_mode).with(0).and_return(:private)
        subject.access_mode!.should == :private
      end
    end

    describe '#access_mode=' do
      it 'sets corresponding access mode' do
        mock_api_server('{"status": "Ok", "result": {"access": 0 }}')
        subject.should_receive(:parse_access_mode).with(:private).and_return(0)
        subject.access_mode = :private
      end
    end

    describe '#formats!' do
      it 'returns an array of symbols' do
        mock_api_server(load_json('document_formats'))
        formats = subject.formats!
        formats.should be_an(Array)
        formats.each do |format|
          format.should be_a(Symbol)
        end
      end
    end

    describe '#parse_access_mode' do
      it 'raise error if mode is unknown' do
        -> { subject.send(:parse_access_mode, 3) }.should raise_error(ArgumentError)
        -> { subject.send(:parse_access_mode, :unknown) }.should raise_error(ArgumentError)
      end

      it 'returns :private if passed mode is 0' do
        subject.send(:parse_access_mode, 0).should == :private
      end

      it 'returns :restricted if passed mode is 1' do
        subject.send(:parse_access_mode, 1).should == :restricted
      end

      it 'returns :public if passed mode is 2' do
        subject.send(:parse_access_mode, 2).should == :public
      end

      it 'returns 0 if passed mode is :private' do
        subject.send(:parse_access_mode, :private).should == 0
      end

      it 'returns 1 if passed mode is :restricted' do
        subject.send(:parse_access_mode, :restricted).should == 1
      end

      it 'returns 2 if passed mode is :public' do
        subject.send(:parse_access_mode, :public).should == 2
      end
    end

  end
end
