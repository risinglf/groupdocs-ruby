require 'spec_helper'

describe GroupDocs::Signature::Field::Location do

  it_behaves_like GroupDocs::Api::Entity

  it { should respond_to(:id)              }
  it { should respond_to(:id)              }
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

  it { should have_alias(:document_id,      :documentId)      }
  it { should have_alias(:document_id=,     :documentId=)     }
  it { should have_alias(:field_id,         :fieldId)         }
  it { should have_alias(:field_id=,        :fieldId=)        }
  it { should have_alias(:location_x,       :locationX)       }
  it { should have_alias(:location_x=,      :locationX=)      }
  it { should have_alias(:location_y,       :locationY)       }
  it { should have_alias(:location_y=,      :locationY=)      }
  it { should have_alias(:location_w,       :locationWidth)   }
  it { should have_alias(:location_w=,      :locationWidth=)  }
  it { should have_alias(:location_width,   :locationWidth)   }
  it { should have_alias(:location_width=,  :locationWidth=)  }
  it { should have_alias(:location_h,       :locationHeight)  }
  it { should have_alias(:location_h=,      :locationHeight=) }
  it { should have_alias(:location_height,  :locationHeight)  }
  it { should have_alias(:location_height=, :locationHeight=) }
  it { should have_alias(:font_name,        :fontName)        }
  it { should have_alias(:font_name=,       :fontName=)       }
  it { should have_alias(:font_color,       :fontColor)       }
  it { should have_alias(:font_color=,      :fontColor=)      }
  it { should have_alias(:font_size,        :fontSize)        }
  it { should have_alias(:font_size=,       :fontSize=)       }
  it { should have_alias(:font_bold,        :fontBold)        }
  it { should have_alias(:font_bold=,       :fontBold=)       }
  it { should have_alias(:font_italic,      :fontItalic)      }
  it { should have_alias(:font_italic=,     :fontItalic=)     }
  it { should have_alias(:font_underline,   :fontUnderline)   }
  it { should have_alias(:font_underline=,  :fontUnderline=)  }

end
