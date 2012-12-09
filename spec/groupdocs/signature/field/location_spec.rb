require 'spec_helper'

describe GroupDocs::Signature::Field::Location do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:id)             }
  it { should have_accessor(:documentId)     }
  it { should have_accessor(:fieldId)        }
  it { should have_accessor(:page)           }
  it { should have_accessor(:locationX)      }
  it { should have_accessor(:locationY)      }
  it { should have_accessor(:locationWidth)  }
  it { should have_accessor(:locationHeight) }
  it { should have_accessor(:fontName)       }
  it { should have_accessor(:fontColor)      }
  it { should have_accessor(:fontSize)       }
  it { should have_accessor(:fontBold)       }
  it { should have_accessor(:fontItalic)     }
  it { should have_accessor(:fontUnderline)  }

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
