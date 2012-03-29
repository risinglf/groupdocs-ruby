require 'spec_helper'

describe GroupDocs::Assembly::DataSource do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('datasource_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(1, {}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options hash' do
      lambda do
        described_class.get!(1, fields: %w(field1 field2))
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::Assembly::DataSource object if datasource is found' do
      described_class.get!(1).should be_a(GroupDocs::Assembly::DataSource)
    end

    it 'returns nil if datasource was not found' do
      mock_api_server('{"result": {"datasource": null}, "status": "Failed"}')
      described_class.get!(99).should be_nil
    end
  end

  it { should respond_to(:id)                }
  it { should respond_to(:id=)               }
  it { should respond_to(:descr)             }
  it { should respond_to(:descr=)            }
  it { should respond_to(:questionnaire_id)  }
  it { should respond_to(:questionnaire_id=) }
  it { should respond_to(:created_on)        }
  it { should respond_to(:created_on=)       }
  it { should respond_to(:modified_on)       }
  it { should respond_to(:modified_on=)      }
  it { should respond_to(:fields)            }
  it { should respond_to(:fields=)           }

  it 'has human-readable accessors' do
    subject.should respond_to(:description)
    subject.should respond_to(:description=)
    subject.method(:description).should  == subject.method(:descr)
    subject.method(:description=).should == subject.method(:descr=)
  end

  describe '#created_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.created_on = 1332950825
      subject.created_on.should be_a(Time)
    end
  end

  describe '#modified_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.modified_on = 1332950825
      subject.modified_on.should be_a(Time)
    end
  end

  describe '#fields=' do
    it 'converts each field to GroupDocs::Assembly::DataSource::Field object' do
      subject.fields = [{ name: 'field1', values: %w(value1 value2), type: 1 }]
      fields = subject.fields
      fields.should be_an(Array)
      fields.each do |field|
        field.should be_a(GroupDocs::Assembly::DataSource::Field)
      end
    end
  end

  describe '#add_field' do
    it 'raises error if field is not GroupDocs::Assembly::DataSource::Field object' do
      -> { subject.add_field('Field') }.should raise_error(ArgumentError)
    end

    it 'saves field' do
      field = GroupDocs::Assembly::DataSource::Field.new
      subject.add_field(field)
      subject.fields.should == [field]
    end
  end

  describe '#add!' do
    before(:each) do
      mock_api_server(load_json('datasource_add'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.add!
    end

    it 'adds ID of datasource from response to self' do
      lambda do
        subject.add!
      end.should change(subject, :id)
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server(load_json('datasource_update'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.add!
    end
  end
end
