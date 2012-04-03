require 'spec_helper'

describe GroupDocs::Assembly::Questionnaire::Question::Answer do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:text)   }
  it { should respond_to(:text=)  }
  it { should respond_to(:value)  }
  it { should respond_to(:value=) }
end
