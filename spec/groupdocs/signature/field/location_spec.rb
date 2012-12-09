require 'spec_helper'

describe GroupDocs::Signature::Field::Location do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:id)              }
  it { should respond_to(:id=)             }
  it { should respond_to(:documentId)      }
  it { should respond_to(:documentId=)     }
  it { should respond_to(:fieldId)         }
  it { should respond_to(:fieldId=)        }
  it { should respond_to(:page)            }
  it { should respond_to(:page=)           }
  it { should respond_to(:locationX)       }
  it { should respond_to(:locationX=)      }
  it { should respond_to(:locationY)       }
  it { should respond_to(:locationY=)      }
  it { should respond_to(:locationWidth)   }
  it { should respond_to(:locationWidth=)  }
  it { should respond_to(:locationHeight)  }
  it { should respond_to(:locationHeight=) }
  it { should respond_to(:fontName)        }
  it { should respond_to(:fontName=)       }
  it { should respond_to(:fontColor)       }
  it { should respond_to(:fontColor=)      }
  it { should respond_to(:fontSize)        }
  it { should respond_to(:fontSize=)       }
  it { should respond_to(:fontBold)        }
  it { should respond_to(:fontBold=)       }
  it { should respond_to(:fontItalic)      }
  it { should respond_to(:fontItalic=)     }
  it { should respond_to(:fontUnderline)   }
  it { should respond_to(:fontUnderline=)  }

  it { should have_aliased_accessor(:document_id,     :documentId)     }
  it { should have_aliased_accessor(:field_id,        :fieldId)        }
  it { should have_aliased_accessor(:location_x,      :locationX)      }
  it { should have_aliased_accessor(:x,               :locationX)      }
  it { should have_aliased_accessor(:location_y,      :locationY)      }
  it { should have_aliased_accessor(:y,               :locationY)      }
  it { should have_aliased_accessor(:location_w,      :locationWidth)  }
  it { should have_aliased_accessor(:location_width,  :locationWidth)  }
  it { should have_aliased_accessor(:w,               :locationWidth)  }
  it { should have_aliased_accessor(:location_h,      :locationHeight) }
  it { should have_aliased_accessor(:location_height, :locationHeight) }
  it { should have_aliased_accessor(:h,               :locationHeight) }
  it { should have_aliased_accessor(:font_name,       :fontName)       }
  it { should have_aliased_accessor(:font_color,      :fontColor)      }
  it { should have_aliased_accessor(:font_size,       :fontSize)       }
  it { should have_aliased_accessor(:font_bold,       :fontBold)       }
  it { should have_aliased_accessor(:font_italic,     :fontItalic)     }
  it { should have_aliased_accessor(:font_underline,  :fontUnderline)  }
end
