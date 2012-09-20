require 'spec_helper'

describe GroupDocs::Signature::Field do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('signature_fields_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!({}, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'allows passing options' do
      -> { described_class.get!(id: "dsaoij3928ukr03") }.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Signature::Field objects' do
      fields = described_class.get!
      fields.should be_an(Array)
      fields.each do |field|
        field.should be_a(GroupDocs::Signature::Field)
      end
    end
  end

  it { should respond_to(:graphSizeW)         }
  it { should respond_to(:graphSizeW=)        }
  it { should respond_to(:graphSizeW)         }
  it { should respond_to(:graphSizeW=)        }
  it { should respond_to(:graphSizeH)         }
  it { should respond_to(:graphSizeH=)        }
  it { should respond_to(:graphSizeH)         }
  it { should respond_to(:graphSizeH=)        }
  it { should respond_to(:getDataFrom)        }
  it { should respond_to(:getDataFrom=)       }
  it { should respond_to(:regularExpression)  }
  it { should respond_to(:regularExpression=) }
  it { should respond_to(:fontName)           }
  it { should respond_to(:fontName=)          }
  it { should respond_to(:fontColor)          }
  it { should respond_to(:fontColor=)         }
  it { should respond_to(:fontSize)           }
  it { should respond_to(:fontSize=)          }
  it { should respond_to(:fontBold)           }
  it { should respond_to(:fontBold=)          }
  it { should respond_to(:fontItalic)         }
  it { should respond_to(:fontItalic=)        }
  it { should respond_to(:fontUnderline)      }
  it { should respond_to(:fontUnderline=)     }
  it { should respond_to(:isSystem)           }
  it { should respond_to(:isSystem=)          }
  it { should respond_to(:fieldType)          }
  it { should respond_to(:fieldType=)         }
  it { should respond_to(:acceptableValues)   }
  it { should respond_to(:acceptableValues=)  }
  it { should respond_to(:defaultValue)       }
  it { should respond_to(:defaultValue=)      }

  it { should have_alias(:graph_size_w,        :graphSizeW)         }
  it { should have_alias(:graph_size_w=,       :graphSizeW=)        }
  it { should have_alias(:graph_size_width,    :graphSizeW)         }
  it { should have_alias(:graph_size_width=,   :graphSizeW=)        }
  it { should have_alias(:graph_size_h,        :graphSizeH)         }
  it { should have_alias(:graph_size_h=,       :graphSizeH=)        }
  it { should have_alias(:graph_size_height,   :graphSizeH)         }
  it { should have_alias(:graph_size_height=,  :graphSizeH=)        }
  it { should have_alias(:get_data_from,       :getDataFrom)        }
  it { should have_alias(:get_data_from=,      :getDataFrom=)       }
  it { should have_alias(:regular_expression,  :regularExpression)  }
  it { should have_alias(:regular_expression=, :regularExpression=) }
  it { should have_alias(:font_name,           :fontName)           }
  it { should have_alias(:font_name=,          :fontName=)          }
  it { should have_alias(:font_color,          :fontColor)          }
  it { should have_alias(:font_color=,         :fontColor=)         }
  it { should have_alias(:font_size,           :fontSize)           }
  it { should have_alias(:font_size=,          :fontSize=)          }
  it { should have_alias(:font_bold,           :fontBold)           }
  it { should have_alias(:font_bold=,          :fontBold=)          }
  it { should have_alias(:font_italic,         :fontItalic)         }
  it { should have_alias(:font_italic=,        :fontItalic=)        }
  it { should have_alias(:font_underline,      :fontUnderline)      }
  it { should have_alias(:font_underline=,     :fontUnderline=)     }
  it { should have_alias(:is_system,           :isSystem)           }
  it { should have_alias(:is_system=,          :isSystem=)          }
  it { should have_alias(:field_type,          :fieldType)          }
  it { should have_alias(:field_type=,         :fieldType=)         }
  it { should have_alias(:acceptable_values,   :acceptableValues)   }
  it { should have_alias(:acceptable_values=,  :acceptableValues=)  }
  it { should have_alias(:default_value,       :defaultValue)       }
  it { should have_alias(:default_value=,      :defaultValue=)      }

  describe '#create!' do
    before(:each) do
      mock_api_server(load_json('signature_field_add'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.create!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.create!
    end

    it 'updates identifier of field' do
      lambda do
        subject.create!
      end.should change(subject, :id)
    end
  end

  describe '#modify!' do
    before(:each) do
      mock_api_server(load_json('signature_field_add'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.modify!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.modify!
    end
  end

  describe '#delete!' do
    before(:each) do
      mock_api_server('{ "status": "Ok", "result": { "field": null }}')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.delete!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end
end
