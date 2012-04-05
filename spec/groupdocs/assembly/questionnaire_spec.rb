require 'spec_helper'

describe GroupDocs::Assembly::Questionnaire do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('questionnaires_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Assembly::Questionnaire objects' do
      questionnaires = described_class.get!
      questionnaires.should be_an(Array)
      questionnaires.each do |questionnaire|
        questionnaire.should be_a(GroupDocs::Assembly::Questionnaire)
      end
    end

    it 'should be aliased to .all!' do
      described_class.should respond_to(:all!)
      described_class.method(:all!).should == described_class.method(:get!)
    end
  end

  describe '.executions!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_executions'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.executions!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Assembly::Questionnaire::Execution objects' do
      executions = described_class.executions!
      executions.should be_an(Array)
      executions.each do |execution|
        execution.should be_a(GroupDocs::Assembly::Questionnaire::Execution)
      end
    end
  end

  it { should respond_to(:pages)  }
  it { should respond_to(:pages=) }

  it 'has human-readable accessors' do
    subject.should respond_to(:description)
    subject.should respond_to(:description=)
    subject.method(:description).should  == subject.method(:descr)
    subject.method(:description=).should == subject.method(:descr=)
  end

  describe '#pages=' do
    it 'converts each page to GroupDocs::Assembly::Questionnaire::Page object if hash is passed' do
      subject.pages = [{ number: 1, title: 'Page1' }, { number: 2, title: 'Page2' }]
      pages = subject.pages
      pages.should be_an(Array)
      pages.each do |page|
        page.should be_a(GroupDocs::Assembly::Questionnaire::Page)
      end
    end

    it 'saves each page if it is GroupDocs::Assembly::Questionnaire::Page object' do
      page1 = GroupDocs::Assembly::Questionnaire::Page.new(number: 1)
      page2 = GroupDocs::Assembly::Questionnaire::Page.new(number: 2)
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
    it 'raises error if page is not GroupDocs::Assembly::Questionnaire::Page object' do
      -> { subject.add_page('Page') }.should raise_error(ArgumentError)
    end

    it 'adds page to pages instance variable' do
      page = GroupDocs::Assembly::Questionnaire::Page.new
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

    it 'adds ID of questionnaire from response to self' do
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

    it 'returns array of GroupDocs::Assembly::DataSource objects' do
      datasources = subject.datasources!
      datasources.should be_an(Array)
      datasources.each do |datasource|
        datasource.should be_a(GroupDocs::Assembly::DataSource)
      end
    end
  end

  describe '#create_execution!' do
    before(:each) do
      mock_api_server(load_json('questionnaire_execution_create'))
    end

    let(:execution) { GroupDocs::Assembly::Questionnaire::Execution.new }
    let(:email)     { 'email@email.com' }

    it 'accepts access credentials hash' do
      lambda do
        subject.create_execution!(execution, email, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if execution is not GroupDocs::Assembly::Questionnaire::Execution object' do
      -> { subject.create_execution!('Execution', email) }.should raise_error(ArgumentError)
    end

    it 'uses hashed version of execution along with executive payload' do
      hash = {}
      execution.should_receive(:to_hash).and_return(hash)
      hash.should_receive(:merge).with({ executive: { primary_email: email } })
      subject.create_execution!(execution, email)
    end

    it 'returns GroupDocs::Assembly::Questionnaire::Execution object' do
      subject.create_execution!(execution, email).should be_a(GroupDocs::Assembly::Questionnaire::Execution)
    end
  end
end
