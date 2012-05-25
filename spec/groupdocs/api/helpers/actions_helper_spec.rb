require 'spec_helper'

describe GroupDocs::Api::Helpers::Actions do

  subject do
    Object.extend(described_class)
  end

  let(:actions) do
    %w(none convert combine compress_zip compress_rar trace convert_body bind_data print import_annotations)
  end

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

  describe '.convert_actions_to_byte' do
    it 'raises error if actions is not an array' do
      -> { subject.convert_actions_to_byte(:convert) }.should raise_error(ArgumentError)
    end

    it 'raises error if action is unknown' do
      -> { subject.convert_actions_to_byte(%w(unknown)) }.should raise_error(ArgumentError)
    end

    it 'converts each action to Symbol' do
      actions = %w(none convert)
      actions.each do |action|
        symbol = action.to_sym
        action.should_receive(:to_sym).and_return(symbol)
      end
      subject.convert_actions_to_byte(actions)
    end

    it 'returns correct byte flag' do
      actions = %w(convert combine compress_zip compress_rar trace convert_body bind_data print import_annotations)
      flag = subject.convert_actions_to_byte(actions)
      flag.should be_an(Integer)
      flag.should == 511
    end
  end

  describe '#convert_byte_to_actions' do
    it 'raises error if byte is not an integer' do
      -> { subject.convert_byte_to_actions('byte') }.should raise_error(ArgumentError)
    end


    it 'returns correct array of actions' do
      subject.convert_byte_to_actions(511).should =~ actions.map(&:to_sym)
    end
  end
end
