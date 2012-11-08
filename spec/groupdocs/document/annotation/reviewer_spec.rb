require 'spec_helper'

describe GroupDocs::Document::Annotation::Reviewer do

  it_behaves_like GroupDocs::Api::Entity

  describe '.all!' do
    before(:each) do
      mock_api_server(load_json('annotation_reviewers_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.all!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Document::Annotation::Reviewer objects' do
      reviewers = described_class.all!
      reviewers.should be_an(Array)
      reviewers.each do |reviewer|
        reviewer.should be_a(GroupDocs::Document::Annotation::Reviewer)
      end
    end
  end

  it { should respond_to(:emailAddress)  }
  it { should respond_to(:emailAddress=) }
  it { should respond_to(:FullName)      }
  it { should respond_to(:FullName=)     }

  it { should have_alias(:email_address,  :emailAddress)  }
  it { should have_alias(:email_address=, :emailAddress=) }
  it { should have_alias(:full_name,  :FullName)          }
  it { should have_alias(:full_name=, :FullName=)         }
end
