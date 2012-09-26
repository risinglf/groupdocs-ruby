require 'spec_helper'

describe GroupDocs::Signature::Envelope do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Signature::DocumentMethods
  include_examples GroupDocs::Signature::EntityFields
  include_examples GroupDocs::Signature::EntityMethods
  include_examples GroupDocs::Signature::FieldMethods
  include_examples GroupDocs::Signature::RecipientMethods
  include_examples GroupDocs::Signature::ResourceMethods

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

  describe '#fill_field!' do
    let(:field)     { GroupDocs::Signature::Field.new(location: { location_x: 0.1, page: 1 }) }
    let(:document)  { GroupDocs::Document.new(file: GroupDocs::Storage::File.new) }
    let(:recipient) { GroupDocs::Signature::Recipient.new }

    before(:each) do
      mock_api_server(load_json('signature_field_add'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.fill_field!('test', field, document, recipient, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if field is not GroupDocs::Signature::Field object' do
      -> { subject.fill_field!('test', 'Field', document, recipient) }.should raise_error(ArgumentError)
    end

    it 'raises error if document is not GroupDocs::Document object' do
      -> { subject.fill_field!('test', field, 'Document', recipient) }.should raise_error(ArgumentError)
    end

    it 'raises error if recipient is not GroupDocs::Signature::Recipient object' do
      -> { subject.fill_field!('test', field, document, 'Recipient') }.should raise_error(ArgumentError)
    end

    it 'returns filled field' do
      subject.fill_field!('test', field, document, recipient).should be_a(GroupDocs::Signature::Field)
    end
  end

  describe '#sign!' do
    let(:recipient) { GroupDocs::Signature::Recipient.new }

    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.sign!(recipient, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if recipient is not GroupDocs::Signature::Recipient object' do
      -> { subject.sign!('Recipient') }.should raise_error(ArgumentError)
    end
  end

  describe '#decline!' do
    let(:recipient) { GroupDocs::Signature::Recipient.new }

    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.decline!(recipient, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if recipient is not GroupDocs::Signature::Recipient object' do
      -> { subject.decline!('Recipient') }.should raise_error(ArgumentError)
    end
  end

  describe '#signed_documents!' do
    before(:each) do
      mock_api_server(File.read('spec/support/files/envelope.zip'))
      subject.stub(name: 'envelope')
    end

    let(:path) { Dir.tmpdir }

    it 'accepts access credentials hash' do
      lambda do
        subject.signed_documents!(path, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'downloads file to given path' do
      file = stub('file')
      Object::File.should_receive(:open).with("#{path}/#{subject.name}.zip", 'w').and_yield(file)
      file.should_receive(:write).with(File.read('spec/support/files/envelope.zip'))
      subject.signed_documents!(path)
    end

    it 'returns saved file path' do
      subject.signed_documents!(path).should == "#{path}/#{subject.name}.zip"
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

  describe '#send!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.send!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#archive!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.archive!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end


  describe '#restart!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": {}}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.archive!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end
end
