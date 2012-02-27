require 'spec_helper'

describe GroupDocs do

  subject { GroupDocs }

  context 'user access' do
    let(:client_id)   { '07aaaf95f8eb33a4' }
    let(:private_key) { '5cb711b3a52ffc5d90ee8a0f79206f5a' }

    describe '#client_id' do
      it { should respond_to(:client_id)  }
      it { should respond_to(:client_id=) }

      it 'should raise error if Client ID has not been set' do
        -> { subject.client_id }.should raise_error(GroupDocs::Errors::NoClientIdError)
      end

      it 'should return Client ID' do
        subject.client_id = client_id
        subject.client_id.should == client_id
      end
    end

    describe '#private_key' do
      it { should respond_to(:private_key)  }
      it { should respond_to(:private_key=) }

      it 'should raise error if private key has not been set' do
        -> { subject.private_key }.should raise_error(GroupDocs::Errors::NoPrivateKeyError)
      end

      it 'should return private Key' do
        subject.private_key = private_key
        subject.private_key.should == private_key
      end
    end

    describe '#configure' do
      it { should respond_to(:configure) }

      it 'should call block for self' do
        subject.should_receive(:configure).and_yield(subject)
        subject.configure do |api|
          api.client_id   = client_id
          api.private_key = private_key
        end
      end

      it 'should save Client ID for further access' do
        subject.should_receive(:client_id=).with(client_id).and_return(client_id)
        subject.configure do |api|
          api.client_id = client_id
        end
        subject.client_id.should == client_id
      end

      it 'should save Private Key for further access' do
        subject.should_receive(:private_key=).with(private_key).and_return(private_key)
        subject.configure do |api|
          api.private_key = private_key
        end
        subject.private_key.should == private_key
      end
    end
  end

  context 'API settings' do
    describe '#api_hostname' do
      it { should respond_to(:api_hostname)  }
      it { should respond_to(:api_hostname=) }

      it 'should return default URL if it has not been overwritten' do
        subject.api_hostname.should == 'dev-api.groupdocs.com'
      end

      it 'should return custom URL' do
        subject.api_hostname = 'api.groupdocs.com'
        subject.api_hostname.should == 'api.groupdocs.com'
      end
    end

    describe '#api_version' do
      it { should respond_to(:api_version)  }
      it { should respond_to(:api_version=) }
    end
  end
end # GroupDocs
