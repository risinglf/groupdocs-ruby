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
        document.should be_a(GroupDocs::Document )
      end
    end
  end

  describe '#documents!' do
    pending 'Receive 404 response.'
  end

  describe '#add_document!' do
    it 'raises error if document is not an instance of GroupDocs::Document' do
      -> { subject.add_document!('Document') }.should raise_error(ArgumentError)
    end

    pending 'Receive "Document not found" response'
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
end
