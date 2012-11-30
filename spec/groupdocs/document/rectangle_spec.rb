require 'spec_helper'

describe GroupDocs::Document::Rectangle do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:x)       }
  it { should respond_to(:x=)      }
  it { should respond_to(:y)       }
  it { should respond_to(:y=)      }
  it { should respond_to(:width)   }
  it { should respond_to(:width=)  }
  it { should respond_to(:height)  }
  it { should respond_to(:height=) }

  it { should have_alias(:w, :width)    }
  it { should have_alias(:w=, :width=)  }
  it { should have_alias(:h, :height)   }
  it { should have_alias(:h=, :height=) }
end
