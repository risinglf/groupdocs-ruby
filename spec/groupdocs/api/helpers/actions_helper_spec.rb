require 'spec_helper'

describe GroupDocs::Api::Helpers::Actions do

  describe 'ACTIONS' do
    it 'contains hash of actions' do
      described_class::ACTIONS.should == {
        none:                 0,
        convert:              1,
        combine:              2,
        compress_zip:         4,
        compress_rar:         8,
        trace:               16,
        convert_body:        32,
        bind_data:           64,
        print:              128,
        import_annotations: 256,
      }
    end
  end

  describe '.convert_actions' do
    it 'raises error if actions is not an array' do
      -> { described_class.convert_actions(:convert) }.should raise_error(ArgumentError)
    end

    it 'raises error if action is unknown' do
      -> { described_class.convert_actions(%w(unknown)) }.should raise_error(ArgumentError)
    end

    it 'converts each action to Symbol' do
      pending 'http://stackoverflow.com/questions/9823121/rspec-mock-ampersand-symbol-parameters'
    end

    it 'returns correct byte flag' do
      actions = %w(none convert combine compress_zip compress_rar trace convert_body bind_data print import_annotations)
      flag = described_class.convert_actions(actions)
      flag.should be_an(Integer)
      flag.should == 511
    end
  end
end
