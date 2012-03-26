require 'spec_helper'

describe GroupDocs::Assembly::DataSource do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:id)       }
  it { should respond_to(:id=)      }
end
