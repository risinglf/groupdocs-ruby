require 'spec_helper'

describe GroupDocs::Signature::Envelope do

  it_behaves_like GroupDocs::Api::Entity

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

  it { should respond_to(:id)                  }
  it { should respond_to(:id=)                 }
  it { should respond_to(:name)                }
  it { should respond_to(:name=)               }
  it { should respond_to(:ownerId)             }
  it { should respond_to(:ownerId=)            }
  it { should respond_to(:ownerGuid)           }
  it { should respond_to(:ownerGuid=)          }
  it { should respond_to(:creationDateTime)    }
  it { should respond_to(:creationDateTime=)   }
  it { should respond_to(:status)              }
  it { should respond_to(:status=)             }
  it { should respond_to(:statusDateTime)      }
  it { should respond_to(:statusDateTime=)     }
  it { should respond_to(:reminderTime)        }
  it { should respond_to(:reminderTime=)       }
  it { should respond_to(:stepExpireTime)      }
  it { should respond_to(:stepExpireTime=)     }
  it { should respond_to(:envelopeExpireTime)  }
  it { should respond_to(:envelopeExpireTime=) }
  it { should respond_to(:ownerShouldSign)     }
  it { should respond_to(:ownerShouldSign=)    }
  it { should respond_to(:orderedSignature)    }
  it { should respond_to(:orderedSignature=)   }
  it { should respond_to(:emailSubject)        }
  it { should respond_to(:emailSubject=)       }
  it { should respond_to(:emailBody)           }
  it { should respond_to(:emailBody=)          }
  it { should respond_to(:documentsCount)      }
  it { should respond_to(:documentsCount=)     }
  it { should respond_to(:documentsPages)      }
  it { should respond_to(:documentsPages=)     }
  it { should respond_to(:recipients)          }
  it { should respond_to(:recipients=)         }

  it 'has human-readable accessors' do
    subject.should respond_to(:owner_id)
    subject.should respond_to(:owner_id=)
    subject.should respond_to(:owner_guid)
    subject.should respond_to(:owner_guid=)
    subject.should respond_to(:creation_date_time)
    subject.should respond_to(:creation_date_time=)
    subject.should respond_to(:status_date_time)
    subject.should respond_to(:status_date_time=)
    subject.should respond_to(:reminder_time)
    subject.should respond_to(:reminder_time=)
    subject.should respond_to(:step_expire_time)
    subject.should respond_to(:step_expire_time=)
    subject.should respond_to(:envelope_expire_time)
    subject.should respond_to(:envelope_expire_time=)
    subject.should respond_to(:owner_should_sign)
    subject.should respond_to(:owner_should_sign=)
    subject.should respond_to(:ordered_signature)
    subject.should respond_to(:ordered_signature=)
    subject.should respond_to(:email_subject)
    subject.should respond_to(:email_subject=)
    subject.should respond_to(:email_body)
    subject.should respond_to(:email_body=)
    subject.should respond_to(:documents_count)
    subject.should respond_to(:documents_count=)
    subject.should respond_to(:documents_pages)
    subject.should respond_to(:documents_pages=)
    subject.method(:owner_id).should              == subject.method(:ownerId)
    subject.method(:owner_id=).should             == subject.method(:ownerId=)
    subject.method(:owner_guid).should            == subject.method(:ownerGuid)
    subject.method(:owner_guid=).should           == subject.method(:ownerGuid=)
    subject.method(:creation_date_time).should    == subject.method(:creationDateTime)
    subject.method(:creation_date_time=).should   == subject.method(:creationDateTime=)
    subject.method(:status_date_time).should      == subject.method(:statusDateTime)
    subject.method(:status_date_time=).should     == subject.method(:statusDateTime=)
    subject.method(:reminder_time).should         == subject.method(:reminderTime)
    subject.method(:reminder_time=).should        == subject.method(:reminderTime=)
    subject.method(:step_expire_time).should      == subject.method(:stepExpireTime)
    subject.method(:step_expire_time=).should     == subject.method(:stepExpireTime=)
    subject.method(:envelope_expire_time).should  == subject.method(:envelopeExpireTime)
    subject.method(:envelope_expire_time=).should == subject.method(:envelopeExpireTime=)
    subject.method(:owner_should_sign).should     == subject.method(:ownerShouldSign)
    subject.method(:owner_should_sign=).should    == subject.method(:ownerShouldSign=)
    subject.method(:ordered_signature).should     == subject.method(:orderedSignature)
    subject.method(:ordered_signature=).should    == subject.method(:orderedSignature=)
    subject.method(:email_subject).should         == subject.method(:emailSubject)
    subject.method(:email_subject=).should        == subject.method(:emailSubject=)
    subject.method(:email_body).should            == subject.method(:emailBody)
    subject.method(:email_body=).should           == subject.method(:emailBody=)
    subject.method(:documents_count).should       == subject.method(:documentsCount)
    subject.method(:documents_count=).should      == subject.method(:documentsCount=)
    subject.method(:documents_pages).should       == subject.method(:documentsPages)
    subject.method(:documents_pages=).should      == subject.method(:documentsPages=)
  end

  describe '#recipients=' do
    it 'converts each recipient to GroupDocs::Signature::Contact object if hash is passed' do
      subject.recipients = [{ firstName: 'John' }]
      recipients = subject.recipients
      recipients.should be_an(Array)
      recipients.each do |recipient|
        recipient.should be_a(GroupDocs::Signature::Contact)
      end
    end

    it 'saves each recipient if it is GroupDocs::Signature::Contact object' do
      recipient1 = GroupDocs::Signature::Contact.new(firstName: 'recipient1')
      recipient2 = GroupDocs::Signature::Contact.new(firstName: 'recipient2')
      subject.recipients = [recipient1, recipient2]
      subject.recipients.should include(recipient1)
      subject.recipients.should include(recipient2)
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.recipients = nil
      end.should_not change(subject, :recipients)
    end
  end
end
