require 'spec_helper'

describe GroupDocs::Subscription do

  it_behaves_like GroupDocs::Api::Entity

  describe '.current!' do
    before(:each) do
      mock_api_server(load_json('subscription_plan_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.current!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Subscription object' do
      described_class.current!.should be_a(GroupDocs::Subscription)
    end
  end

  it { should respond_to(:ref_id)  }
  it { should respond_to(:ref_id=) }
  it { should respond_to(:Name)    }
  it { should respond_to(:Name=)   }

  it 'has human-readable accessors' do
    subject.should respond_to(:name)
    subject.should respond_to(:name=)
    subject.method(:name).should  == subject.method(:Name)
    subject.method(:name=).should == subject.method(:Name=)
  end
end
