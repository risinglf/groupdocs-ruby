require 'spec_helper'

describe GroupDocs::Assembly::DataSource do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:id)                }
  it { should respond_to(:id=)               }
  it { should respond_to(:questionnaire_id)  }
  it { should respond_to(:questionnaire_id=) }
  it { should respond_to(:created_on)        }
  it { should respond_to(:created_on=)       }
  it { should respond_to(:modified_on)       }
  it { should respond_to(:modified_on=)      }
  it { should respond_to(:fields)            }
  it { should respond_to(:fields=)           }

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
end
