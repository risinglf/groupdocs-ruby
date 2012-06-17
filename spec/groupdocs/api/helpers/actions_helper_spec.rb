require 'spec_helper'

describe GroupDocs::Api::Helpers::Actions do

  subject do
    Object.extend(described_class)
  end

  let(:actions) do
    %w(convert combine compress_zip compress_rar trace convert_body bind_data print import_annotations)
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
      flag = subject.convert_actions_to_byte(actions)
      flag.should be_an(Integer)
      flag.should == 511
    end
  end
end
