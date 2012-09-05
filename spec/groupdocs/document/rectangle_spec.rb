require 'spec_helper'

describe GroupDocs::Document::Rectangle do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:X)       }
  it { should respond_to(:X=)      }
  it { should respond_to(:Y)       }
  it { should respond_to(:Y=)      }
  it { should respond_to(:Width)   }
  it { should respond_to(:Width=)  }
  it { should respond_to(:Height)  }
  it { should respond_to(:Height=) }

  it { should have_alias(:x, :X)        }
  it { should have_alias(:x=, :X=)      }
  it { should have_alias(:y, :Y)        }
  it { should have_alias(:y=, :Y=)      }
  it { should have_alias(:w, :Width)    }
  it { should have_alias(:w=, :Width=)  }
  it { should have_alias(:width, :w)    }
  it { should have_alias(:h, :Height)   }
  it { should have_alias(:h=, :Height=) }
  it { should have_alias(:height, :h)   }
end
