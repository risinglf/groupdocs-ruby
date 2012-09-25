require 'spec_helper'

describe GroupDocs::Signature::Envelope do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Signature::DocumentMethods
  include_examples GroupDocs::Signature::EntityFields
  include_examples GroupDocs::Signature::EntityMethods
  include_examples GroupDocs::Signature::FieldMethods
  include_examples GroupDocs::Signature::RecipientMethods

  describe '.all!' do
    before(:each) do
      mock_api_server(load_json('envelopes_all'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.all!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      -> { described_class.all!(page: 1, count: 3) }.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::Envelope objects' do
      envelopes = described_class.all!
      envelopes.should be_an(Array)
      envelopes.each do |envelope|
        envelope.should be_a(GroupDocs::Signature::Envelope)
      end
    end
  end

  describe '.for_me!' do
    before(:each) do
      mock_api_server(load_json('envelopes_all'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.for_me!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      -> { described_class.for_me!(page: 1, count: 3) }.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::Envelope objects' do
      envelopes = described_class.for_me!
      envelopes.should be_an(Array)
      envelopes.each do |envelope|
        envelope.should be_a(GroupDocs::Signature::Envelope)
      end
    end
  end

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('envelope_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!("j5498fre9fje9f", client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Signature::Envelope objects' do
      described_class.get!("j5498fre9fje9f").should be_a(GroupDocs::Signature::Envelope)
    end
  end

  describe '.resources!' do
    before(:each) do
      mock_api_server(load_json('envelopes_resources'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.resources!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      -> { described_class.resources!(status_ids: %w(sdfj943fjof043fj)) }.should_not raise_error(ArgumentError)
    end

    it 'returns resources hash' do
      described_class.resources!.should be_a(Hash)
    end

    it 'returns hash with documents as array of GroupDocs::Document objects' do
      documents = described_class.resources![:documents]
      documents.should be_an(Array)
      documents.each do |document|
        document.should be_a(GroupDocs::Document)
      end
    end

    it 'returns hash with recipients as array of GroupDocs::Signature::Recipient objects' do
      recipients = described_class.resources![:recipients]
      recipients.should be_an(Array)
      recipients.each do |recipient|
        recipient.should be_a(GroupDocs::Signature::Recipient)
      end
    end

    it 'returns hash with dates as array of strings' do
      dates = described_class.resources![:dates]
      dates.should be_an(Array)
      dates.each do |date|
        date.should be_a(String)
      end
    end
  end

  it { should respond_to(:creationDateTime)    }
  it { should respond_to(:creationDateTime=)   }
  it { should respond_to(:status)              }
  it { should respond_to(:status=)             }
  it { should respond_to(:statusDateTime)      }
  it { should respond_to(:statusDateTime=)     }
  it { should respond_to(:envelopeExpireTime)  }
  it { should respond_to(:envelopeExpireTime=) }

  it { should have_alias(:creation_date_time, :creationDateTime)       }
  it { should have_alias(:creation_date_time=, :creationDateTime=)     }
  it { should have_alias(:status_date_time, :statusDateTime)           }
  it { should have_alias(:status_date_time=, :statusDateTime=)         }
  it { should have_alias(:envelope_expire_time, :envelopeExpireTime)   }
  it { should have_alias(:envelope_expire_time=, :envelopeExpireTime=) }

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

  describe '#logs!' do
    before(:each) do
      mock_api_server(load_json('envelope_logs'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.logs!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::Envelope::Log objects' do
      logs = subject.logs!
      logs.should be_an(Array)
      logs.each do |log|
        log.should be_a(GroupDocs::Signature::Envelope::Log)
      end
    end
  end
end
