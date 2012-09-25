require 'spec_helper'

describe GroupDocs::Signature::Template do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Signature::DocumentMethods
  include_examples GroupDocs::Signature::EntityFields
  include_examples GroupDocs::Signature::EntityMethods
  include_examples GroupDocs::Signature::FieldMethods
  include_examples GroupDocs::Signature::RecipientMethods
  include_examples GroupDocs::Signature::ResourceMethods

  describe '.all!' do
    before(:each) do
      mock_api_server(load_json('templates_all'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.all!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      -> { described_class.all!(page: 1, count: 3) }.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::Template objects' do
      templates = described_class.all!
      templates.should be_an(Array)
      templates.each do |template|
        template.should be_a(GroupDocs::Signature::Template)
      end
    end
  end

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('template_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!("j5498fre9fje9f", client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Signature::Template objects' do
      described_class.get!("j5498fre9fje9f").should be_a(GroupDocs::Signature::Template)
    end
  end

  it { should respond_to(:templateExpireTime)  }
  it { should respond_to(:templateExpireTime=) }

  it { should have_alias(:template_expire_time, :templateExpireTime)   }
  it { should have_alias(:template_expire_time=, :templateExpireTime=) }

  describe '#add_recipient!' do
    let(:recipient) do
      GroupDocs::Signature::Recipient.new
    end

    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add_recipient!(recipient, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if recipient is not GroupDocs::Signature::Recipient object' do
      -> { subject.add_recipient!('Recipient') }.should raise_error(ArgumentError)
    end
  end

  describe '#modify_recipient!' do
    let(:recipient) do
      GroupDocs::Signature::Recipient.new
    end

    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.modify_recipient!(recipient, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if recipient is not GroupDocs::Signature::Recipient object' do
      -> { subject.modify_recipient!('Recipient') }.should raise_error(ArgumentError)
    end
  end
end
