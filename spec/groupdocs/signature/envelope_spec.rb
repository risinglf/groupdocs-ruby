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

  it { should have_alias(:owner_id, :ownerId)                          }
  it { should have_alias(:owner_id=, :ownerId=)                        }
  it { should have_alias(:owner_guid, :ownerGuid)                      }
  it { should have_alias(:owner_guid=, :ownerGuid=)                    }
  it { should have_alias(:creation_date_time, :creationDateTime)       }
  it { should have_alias(:creation_date_time=, :creationDateTime=)     }
  it { should have_alias(:status_date_time, :statusDateTime)           }
  it { should have_alias(:status_date_time=, :statusDateTime=)         }
  it { should have_alias(:reminder_time, :reminderTime)                }
  it { should have_alias(:reminder_time=, :reminderTime=)              }
  it { should have_alias(:step_expire_time, :stepExpireTime)           }
  it { should have_alias(:step_expire_time=, :stepExpireTime=)         }
  it { should have_alias(:envelope_expire_time, :envelopeExpireTime)   }
  it { should have_alias(:envelope_expire_time=, :envelopeExpireTime=) }
  it { should have_alias(:owner_should_sign, :ownerShouldSign)         }
  it { should have_alias(:owner_should_sign=, :ownerShouldSign=)       }
  it { should have_alias(:ordered_signature, :orderedSignature)        }
  it { should have_alias(:ordered_signature=, :orderedSignature=)      }
  it { should have_alias(:email_subject, :emailSubject)                }
  it { should have_alias(:email_subject=, :emailSubject=)              }
  it { should have_alias(:email_body, :emailBody)                      }
  it { should have_alias(:email_body=, :emailBody=)                    }
  it { should have_alias(:documents_count, :documentsCount)            }
  it { should have_alias(:documents_count=, :documentsCount=)          }
  it { should have_alias(:documents_pages, :documentsPages)            }
  it { should have_alias(:documents_pages=, :documentsPages=)          }

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
