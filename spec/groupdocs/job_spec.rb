require 'spec_helper'

describe GroupDocs::Job do

  it_behaves_like GroupDocs::Api::Entity
  include_examples GroupDocs::Api::Helpers::Status

  describe '.all!' do
    before(:each) do
      mock_api_server(load_json('jobs_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.all!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        described_class.all!(page: 1, count: 2)
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Job objects' do
      jobs = described_class.all!
      jobs.should be_an(Array)
      jobs.each do |job|
        job.should be_a(GroupDocs::Job)
      end
    end
  end

  describe '.create!' do
    before(:each) do
      mock_api_server(load_json('job_create'))
    end

    let(:actions) { %w(convert compress_zip) }

    it 'accepts access credentials hash' do
      lambda do
        described_class.create!({ actions: %w(convert) }, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if actions are passed' do
      -> { described_class.create!({}) }.should raise_error(ArgumentError)
    end

    it 'convert actions to byte flag' do
      GroupDocs::Api::Helpers::Actions.should_receive(:convert_actions).with(actions).and_return(5)
      described_class.create!(actions: actions)
    end

    it 'converts array of out formats to string' do
      formats = %w(pdf txt)
      formats.should_receive(:join).with(?;)
      described_class.create!(actions: actions, out_formats: formats)
    end

    it 'returns GroupDocs::Job object' do
      described_class.create!(actions: actions).should be_a(GroupDocs::Job)
    end
  end

  it { should respond_to(:id)         }
  it { should respond_to(:id=)        }
  it { should respond_to(:documents)  }
  it { should respond_to(:documents=) }

  describe '#documents=' do
    let(:response) do
      [{ id: 1, guid: 'fhy9yh94u238dgf', status: 0, outputs: [] },
       { id: 2, guid: 'ofh9rhy9rfohf9s', status: 2, outputs: [] }]
    end

    it 'saves documents as array of GroupDocs::Document objects' do
      subject.documents = response
      documents = subject.documents
      documents.should be_an(Array)
      documents.each do |document|
        document.should be_a(GroupDocs::Document)
      end
    end
  end

  describe '#documents!' do
    before(:each) do
      mock_api_server(load_json('job_documents'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.documents!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Document objects' do
      documents = subject.documents!
      documents.should be_an(Array)
      documents.each do |document|
        document.should be_a(GroupDocs::Document)
      end
    end
  end

  describe '#add_document!' do
    before(:each) do
      mock_api_server(load_json('job_file_add'))
    end

    let(:document) do
      GroupDocs::Document.new(file: GroupDocs::Storage::File.new)
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add_document!(document, {}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.add_document!(document, output_formats: %w(pdf txt))
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if document is not an instance of GroupDocs::Document' do
      -> { subject.add_document!('Document') }.should raise_error(ArgumentError)
    end

    it 'returns document ID' do
      subject.add_document!(document).should be_an(Integer)
    end
  end

  describe '#add_datasource!' do
    let(:document) do
      GroupDocs::Document.new(file: GroupDocs::Storage::File.new)
    end

    let(:datasource) do
      GroupDocs::DataSource.new
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add_datasource!(document, datasource, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if document is not an instance of GroupDocs::Document' do
      -> { subject.add_datasource!('Document') }.should raise_error(ArgumentError)
    end

    it 'raises error if datasource is not an instance of GroupDocs::DataSource' do
      -> { subject.add_datasource!(document, 'DataSource') }.should raise_error(ArgumentError)
    end
  end

  describe '#add_url!' do
    before(:each) do
      mock_api_server(load_json('job_add_url'))
    end

    let(:url) { 'http://www.google.com' }

    it 'accepts access credentials hash' do
      lambda do
        subject.add_url!(url, {}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        subject.add_url!(url, out_formats: %W(pdf txt))
      end.should_not raise_error(ArgumentError)
    end

    it 'returns document ID' do
      subject.add_url!(url).should be_an(Integer)
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server(load_json('job_update'))
    end

    it 'parses status' do
      subject.should_receive(:parse_status).with(:draft).and_return(-1)
      subject.update!(status: :draft)
    end
  end
end
