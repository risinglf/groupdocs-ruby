require 'spec_helper'

describe GroupDocs::Document::Rectangle do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:x)  }
  it { should respond_to(:x=) }
  it { should respond_to(:y)  }
  it { should respond_to(:y=) }
  it { should respond_to(:w)  }
  it { should respond_to(:w=) }
  it { should respond_to(:h)  }
  it { should respond_to(:h=) }
end
