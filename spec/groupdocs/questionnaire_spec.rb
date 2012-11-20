require 'spec_helper'

describe GroupDocs::Questionnaire do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::Status

  describe '.all!' do
    before(:each) do
      mock_api_server(load_json('questionnaires_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.all!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        described_class.all!(status: :draft)
      end.should_not raise_error(ArgumentError)
    end

    it 'parses status if passed' do
      status = :draft
      subject = described_class.new
      described_class.should_receive(:new).any_number_of_times.and_return(subject)
      subject.should_receive(:parse_status).with(status)
      described_class.all!(status: status)
    end

    it 'returns an array of GroupDocs::Questionnaire objects' do
      questionnaires = described_class.all!
      questionnaires.should be_an(Array)
      questionnaires.each do |questionnaire|
        questionnaire.should be_a(GroupDocs::Questionnaire)
      end
    end
  end

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(1, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Questionnaire object' do
      described_class.get!(1).should be_a(GroupDocs::Questionnaire)
    end

    it 'returns nil if ResourceNotFound was raised' do
      GroupDocs::Api::Request.any_instance.should_receive(:execute!).and_raise(RestClient::ResourceNotFound)
      described_class.get!(1).should be_nil
    end
  end

  it { should respond_to(:id)                   }
  it { should respond_to(:id=)                  }
  it { should respond_to(:guid)                 }
  it { should respond_to(:guid=)                }
  it { should respond_to(:name)                 }
  it { should respond_to(:name=)                }
  it { should respond_to(:descr)                }
  it { should respond_to(:descr=)               }
  it { should respond_to(:pages)                }
  it { should respond_to(:pages=)               }
  it { should respond_to(:resolved_executions)  }
  it { should respond_to(:resolved_executions=) }
  it { should respond_to(:assigned_questions)   }
  it { should respond_to(:assigned_questions=)  }
  it { should respond_to(:total_questions)      }
  it { should respond_to(:total_questions=)     }
  it { should respond_to(:modified)             }
  it { should respond_to(:modified=)            }
  it { should respond_to(:expires)              }
  it { should respond_to(:expires=)             }
  it { should respond_to(:document_ids)         }
  it { should respond_to(:document_ids=)        }

  it { should have_alias(:description, :descr)   }
  it { should have_alias(:description=, :descr=) }

  describe '#pages=' do
    it 'converts each page to GroupDocs::Questionnaire::Page object if hash is passed' do
      subject.pages = [{ number: 1, title: 'Page1' }, { number: 2, title: 'Page2' }]
      pages = subject.pages
      pages.should be_an(Array)
      pages.each do |page|
        page.should be_a(GroupDocs::Questionnaire::Page)
      end
    end

    it 'saves each page if it is GroupDocs::Questionnaire::Page object' do
      page1 = GroupDocs::Questionnaire::Page.new(number: 1)
      page2 = GroupDocs::Questionnaire::Page.new(number: 2)
      subject.pages = [page1, page2]
      subject.pages.should include(page1)
      subject.pages.should include(page2)
    end

    it 'does nothing if nil is passed' do
      lambda do
        subject.pages = nil
      end.should_not change(subject, :pages)
    end
  end

  describe '#add_page' do
    it 'raises error if page is not GroupDocs::Questionnaire::Page object' do
      -> { subject.add_page('Page') }.should raise_error(ArgumentError)
    end

    it 'adds page to pages instance variable' do
      page = GroupDocs::Questionnaire::Page.new
      lambda do
        subject.add_page(page)
      end.should change(subject, :pages).to([page])
    end
  end

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_create'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.create!
    end

    it 'updates identifier of questionnaire' do
      lambda do
        subject.create!
      end.should change(subject, :id)
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_update'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.update!
    end
  end

  describe '#remove!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_remove'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.remove!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#datasources!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_datasources'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.datasources!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::DataSource objects' do
      datasources = subject.datasources!
      datasources.should be_an(Array)
      datasources.each do |datasource|
        datasource.should be_a(GroupDocs::DataSource)
      end
    end
  end

  describe '#executions!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_executions'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.executions!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Questionnaire::Execution objects' do
      executions = subject.executions!
      executions.should be_an(Array)
      executions.each do |execution|
        execution.should be_a(GroupDocs::Questionnaire::Execution)
      end
    end
  end

  describe '#create_execution!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_execution_create'))
    end

    let(:execution) { GroupDocs::Questionnaire::Execution.new }
    let(:email)     { 'email@email.com' }

    it 'accepts access credentials hash' do
      lambda do
        subject.create_execution!(execution, email, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if execution is not GroupDocs::Questionnaire::Execution object' do
      -> { subject.create_execution!('Execution', email) }.should raise_error(ArgumentError)
    end

    it 'uses hashed version of execution along with executive payload' do
      hash = {}
      execution.should_receive(:to_hash).and_return(hash)
      hash.should_receive(:merge).with({ executive: { primary_email: email } })
      subject.create_execution!(execution, email)
    end

    it 'returns GroupDocs::Questionnaire::Execution object' do
      subject.create_execution!(execution, email).should be_a(GroupDocs::Questionnaire::Execution)
    end
  end

  describe '#collectors!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_collectors'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.collectors!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Questionnaire::Execution objects' do
      collectors = subject.collectors!
      collectors.should be_an(Array)
      collectors.each do |collector|
        collector.should be_a(GroupDocs::Questionnaire::Collector)
      end
    end
  end
end
