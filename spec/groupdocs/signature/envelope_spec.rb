require 'spec_helper'

describe GroupDocs::Signature::Envelope do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Signature::TemplateFields

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

end
