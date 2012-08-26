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

  it { should respond_to(:Id)                    }
  it { should respond_to(:Id=)                   }
  it { should respond_to(:Name)                  }
  it { should respond_to(:Name=)                 }
  it { should respond_to(:PricingPlanId)         }
  it { should respond_to(:PricingPlanId=)        }
  it { should respond_to(:Price)                 }
  it { should respond_to(:Price=)                }
  it { should respond_to(:CurrencyCode)          }
  it { should respond_to(:CurrencyCode=)         }

  it 'has human-readable accessors' do
    subject.should respond_to(:id)
    subject.should respond_to(:id=)
    subject.should respond_to(:name)
    subject.should respond_to(:name=)
    subject.should respond_to(:pricing_plan_id)
    subject.should respond_to(:pricing_plan_id=)
    subject.should respond_to(:price)
    subject.should respond_to(:price=)
    subject.should respond_to(:currency_code)
    subject.should respond_to(:currency_code=)
    subject.method(:id).should               == subject.method(:Id)
    subject.method(:id=).should              == subject.method(:Id=)
    subject.method(:name).should             == subject.method(:Name)
    subject.method(:name=).should            == subject.method(:Name=)
    subject.method(:pricing_plan_id).should  == subject.method(:PricingPlanId)
    subject.method(:pricing_plan_id=).should == subject.method(:PricingPlanId=)
    subject.method(:price).should            == subject.method(:Price)
    subject.method(:price=).should           == subject.method(:Price=)
    subject.method(:currency_code).should    == subject.method(:CurrencyCode)
    subject.method(:currency_code=).should   == subject.method(:CurrencyCode=)
  end

  it 'is compatible with response JSON' do
    subject.should respond_to(:ref_id=)
    subject.method(:ref_id=).should == subject.method(:id=)
  end

  GroupDocs::Subscription::LIMITS.each do |snake, camel|
    it { should respond_to(:"#{camel}")  }
    it { should respond_to(:"#{camel}=") }

    it 'has human-readable accessors' do
      subject.should respond_to(:"#{snake}")
      subject.should respond_to(:"#{snake}=")
      # reader is overwritten
      subject.method(:"#{snake}=").should == subject.method(:"#{camel}=")
    end

    describe snake do
      it 'converts hash to GroupDocs::Subscription::Limit object' do
        subject.send(:"#{snake}=", { Id: 1, Min: 2, Max: 3, Description: 'Description' })
        limit = subject.send(snake)
        limit.should be_a(GroupDocs::Subscription::Limit)
        limit.id.should          == 1
        limit.min.should         == 2
        limit.max.should         == 3
        limit.description.should == 'Description'
      end
    end
  end
end
