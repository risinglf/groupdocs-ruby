shared_examples_for GroupDocs::Signature::EntityFields do

  it { should respond_to(:id)                }
  it { should respond_to(:id=)               }
  it { should respond_to(:name)              }
  it { should respond_to(:name=)             }
  it { should respond_to(:ownerId)           }
  it { should respond_to(:ownerId=)          }
  it { should respond_to(:ownerGuid)         }
  it { should respond_to(:ownerGuid=)        }
  it { should respond_to(:reminderTime)      }
  it { should respond_to(:reminderTime=)     }
  it { should respond_to(:stepExpireTime)    }
  it { should respond_to(:stepExpireTime=)   }
  it { should respond_to(:ownerShouldSign)   }
  it { should respond_to(:ownerShouldSign=)  }
  it { should respond_to(:orderedSignature)  }
  it { should respond_to(:orderedSignature=) }
  it { should respond_to(:emailSubject)      }
  it { should respond_to(:emailSubject=)     }
  it { should respond_to(:emailBody)         }
  it { should respond_to(:emailBody=)        }
  it { should respond_to(:documentsCount)    }
  it { should respond_to(:documentsCount=)   }
  it { should respond_to(:documentsPages)    }
  it { should respond_to(:documentsPages=)   }
  it { should respond_to(:recipients)        }
  it { should respond_to(:recipients=)       }

  it { should have_alias(:owner_id, :ownerId)                     }
  it { should have_alias(:owner_id=, :ownerId=)                   }
  it { should have_alias(:owner_guid, :ownerGuid)                 }
  it { should have_alias(:owner_guid=, :ownerGuid=)               }
  it { should have_alias(:reminder_time, :reminderTime)           }
  it { should have_alias(:reminder_time=, :reminderTime=)         }
  it { should have_alias(:step_expire_time, :stepExpireTime)      }
  it { should have_alias(:step_expire_time=, :stepExpireTime=)    }
  # owner_should_sign is overwritten
  it { should have_alias(:owner_should_sign=, :ownerShouldSign=)  }
  # ordered_signature is overwritten
  it { should have_alias(:ordered_signature=, :orderedSignature=) }
  it { should have_alias(:email_subject, :emailSubject)           }
  it { should have_alias(:email_subject=, :emailSubject=)         }
  it { should have_alias(:email_body, :emailBody)                 }
  it { should have_alias(:email_body=, :emailBody=)               }
  it { should have_alias(:documents_count, :documentsCount)       }
  it { should have_alias(:documents_count=, :documentsCount=)     }
  it { should have_alias(:documents_pages, :documentsPages)       }
  it { should have_alias(:documents_pages=, :documentsPages=)     }

  describe '#recipients=' do
    it 'converts each recipient to GroupDocs::Signature::Recipient object if hash is passed' do
      subject.recipients = [{ nickname: 'John' }]
      recipients = subject.recipients
      recipients.should be_an(Array)
      recipients.each do |recipient|
        recipient.should be_a(GroupDocs::Signature::Recipient)
      end
    end

    it 'saves each recipient if it is GroupDocs::Signature::Recipient object' do
      recipient1 = GroupDocs::Signature::Recipient.new(nickname: 'recipient1')
      recipient2 = GroupDocs::Signature::Recipient.new(nickname: 'recipient2')
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

  describe '#owner_should_sign' do
    it 'returns true if owner should sign' do
      subject.owner_should_sign = 1
      subject.owner_should_sign.should be_true
    end
  end

  describe '#ordered_signature' do
    it 'returns :ordered for ordered entity' do
      subject.owner_should_sign = 1
      subject.ordered_signature.should == :ordered
    end
  end
end
