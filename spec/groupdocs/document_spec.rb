require 'spec_helper'

describe GroupDocs::Document do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Sugar::Lookup
  include_examples GroupDocs::Api::Helpers::Status

  subject do
    file = GroupDocs::Storage::File.new
    described_class.new(file: file)
  end

  describe '.views!' do
    before(:each) do
      mock_api_server(load_json('document_views'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.views!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'adds page index option by default' do
      GroupDocs::Api::Request.any_instance.should_receive(:add_params).with({ page_index: 0 })
      described_class.views!
    end

    it 'returns an array of GroupDocs::Document::View objects' do
      views = described_class.views!
      views.should be_an(Array)
      views.each do |view|
        view.should be_a(GroupDocs::Document::View)
      end
    end
  end

  describe '.all!' do
    it 'accepts access credentials hash' do
      lambda do
        described_class.all!('/', client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'calls GroupDocs::Storage::File.all! and converts each file to document' do
      file1 = GroupDocs::Storage::File.new
      file2 = GroupDocs::Storage::File.new
      GroupDocs::Storage::File.should_receive(:all!).with('/', {}).and_return([file1, file2])
      file1.should_receive(:to_document).and_return(described_class.new(file: file1))
      file2.should_receive(:to_document).and_return(described_class.new(file: file2))
      described_class.all!
    end
  end

  it { should respond_to(:file)          }
  it { should respond_to(:file=)         }
  it { should respond_to(:process_date)  }
  it { should respond_to(:process_date=) }
  it { should respond_to(:outputs)       }
  it { should respond_to(:outputs=)      }

  it 'is compatible with response JSON' do
    subject.should respond_to(:proc_date=)
    subject.method(:proc_date=).should == subject.method(:process_date=)
  end

  describe '#process_date=' do
    it 'modifies timestamp to Time object' do
      subject.process_date = 1330450135
      subject.process_date.should be_a(Time)
    end
  end

  describe '#initialize' do
    it 'raises error if file is not specified' do
      -> { described_class.new }.should raise_error(ArgumentError)
    end

    it 'raises error if file is not an instance of GroupDocs::Storage::File' do
      -> { described_class.new(file: '') }.should raise_error(ArgumentError)
    end
  end

  describe '#access_mode!' do
    before(:each) do
      mock_api_server(load_json('document_access_info_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.access_mode!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns access mode in human readable presentation' do
      subject.should_receive(:parse_access_mode).with(0).and_return(:private)
      subject.access_mode!.should == :private
    end
  end

  describe '#access_mode_set!' do
    before(:each) do
      mock_api_server('{"status": "Ok", "result": {"access": 0 }}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.access_mode_set!(:private, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'sets corresponding access mode and determines set' do
      subject.should_receive(:parse_access_mode).with(:private).and_return(0)
      subject.should_receive(:parse_access_mode).with(0).and_return(:private)
      subject.access_mode_set!(:private)
    end

    it 'returns set of access modes' do
      subject.access_mode_set!(:private).should == :private
    end

    it 'is aliased to #access_mode=' do
      subject.should respond_to(:access_mode=)
      subject.method(:access_mode=).should == subject.method(:access_mode_set!)
    end
  end

  describe '#formats!' do
    before(:each) do
      mock_api_server(load_json('document_formats'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.formats!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of symbols' do
      formats = subject.formats!
      formats.should be_an(Array)
      formats.each do |format|
        format.should be_a(Symbol)
      end
    end
  end

  describe '#metadata!' do
    before(:each) do
      mock_api_server(load_json('document_metadata'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.metadata!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Document::MetaData object' do
      subject.metadata!.should be_a(GroupDocs::Document::MetaData)
    end

    it 'sets last view as GroupDocs::Document::View object if document was viewed at least once' do
      subject.metadata!.last_view.should be_a(GroupDocs::Document::View)
    end

    it 'uses self document in last view object' do
      subject.metadata!.last_view.document.should == subject
    end

    it 'does not set last view if document has never been viewed' do
      mock_api_server('{"status": "Ok", "result": {"last_view": null }}')
      subject.metadata!.last_view.should be_nil
    end
  end

  describe '#fields!' do
    before(:each) do
      mock_api_server(load_json('document_fields'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.fields!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Document::Field objects' do
      fields = subject.fields!
      fields.should be_an(Array)
      fields.each do |field|
        field.should be_a(GroupDocs::Document::Field)
      end
    end
  end

  describe '#thumbnail!' do
    before(:each) do
      mock_api_server(load_json('document_thumbnail'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.thumbnail!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.thumbnail!(page_number: 1, page_count: 2, use_pdf: true)
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#sharers!' do
    before(:each) do
      mock_api_server(load_json('document_access_info_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.sharers!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::User objects' do
      users = subject.sharers!
      users.should be_an(Array)
      users.each do |user|
        user.should be_a(GroupDocs::User)
      end
    end
  end

  describe '#sharers_set!' do
    before(:each) do
      mock_api_server(load_json('document_sharers_set'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.sharers_set!(%w(test1@email.com), client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::User objects' do
      users = subject.sharers_set!(%w(test1@email.com))
      users.should be_an(Array)
      users.each do |user|
        user.should be_a(GroupDocs::User)
      end
    end

    it 'clears sharers if empty array is passed' do
      subject.should_receive(:sharers_clear!)
      subject.sharers_set!([])
    end

    it 'clears sharers if nil is passed' do
      subject.should_receive(:sharers_clear!)
      subject.sharers_set!(nil)
    end

    it 'is aliased to #sharers=' do
      subject.should respond_to(:sharers=)
      subject.method(:sharers=).should == subject.method(:sharers_set!)
    end
  end

  describe '#sharers_clear!' do
    before(:each) do
      mock_api_server(load_json('document_sharers_remove'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.sharers_clear!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'clears sharers list and returns nil' do
      subject.sharers_clear!.should be_nil
    end
  end

  describe '#convert!' do
    before(:each) do
      mock_api_server(load_json('document_convert'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.convert!(:pdf, {}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.convert!(:pdf, email_results: true)
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Job object' do
      subject.convert!(:pdf).should be_a(GroupDocs::Job)
    end
  end

  describe '#add_questionnaire!' do
    let(:questionnaire) do
      GroupDocs::Assembly::Questionnaire.new(id: 1)
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add_questionnaire!(questionnaire, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if questionnaire is not GroupDocs::Assembly::Questionnaire object' do
      -> { subject.add_questionnaire!('Questionnaire') }.should raise_error(ArgumentError)
    end
  end

  describe '#create_questionnaire!' do
    before(:each) do
      mock_api_server(load_json('document_questionnaire_create'))
    end

    let(:questionnaire) do
      GroupDocs::Assembly::Questionnaire.new(name: 'Q1')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create_questionnaire!(questionnaire, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if questionnaire is not GroupDocs::Assembly::Questionnaire object' do
      -> { subject.create_questionnaire!('Questionnaire') }.should raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Assembly::Questionnaire object' do
      subject.create_questionnaire!(questionnaire).should be_a(GroupDocs::Assembly::Questionnaire)
    end

    it 'uses hashed version of questionnaire as request body' do
      questionnaire.should_receive(:to_hash)
      subject.create_questionnaire!(questionnaire)
    end

    it 'adds ID from response to questionnaire' do
      lambda do
        subject.create_questionnaire!(questionnaire)
      end.should change(questionnaire, :id)
    end
  end

  describe '#method_missing' do
    it 'passes unknown methods to file object' do
      -> { subject.name }.should_not raise_error(NoMethodError)
    end

    it 'raises NoMethodError if neither self nor file responds to method' do
      -> { subject.unknown_method }.should raise_error(NoMethodError)
    end
  end

  describe '#respond_to?' do
    it 'returns true if self responds to method' do
      subject.respond_to?(:metadata!).should be_true
    end

    it 'returns true if file object responds to method' do
      subject.respond_to?(:name).should be_true
    end

    it 'returns false if neither self nor file responds to method' do
      subject.respond_to?(:unknown).should be_false
    end
  end
end
