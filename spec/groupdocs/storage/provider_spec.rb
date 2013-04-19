require 'spec_helper'

describe GroupDocs::Storage::Provider do

  it_behaves_like GroupDocs::Api::Entity

  it { should have_accessor(:id)          }
  it { should have_accessor(:provider)    }
  it { should have_accessor(:type)        }
  it { should have_accessor(:token)       }
  it { should have_accessor(:publicKey)   }
  it { should have_accessor(:privateKey)  }
  it { should have_accessor(:rootFolder)  }
  it { should have_accessor(:isPrimary)   }
  it { should have_accessor(:serviceHost) }
  
  it { should alias_accessor(:public_key, :publicKey)     }
  it { should alias_accessor(:private_key, :privateKey)   }
  it { should alias_accessor(:root_folder, :rootFolder)   }
  it { should alias_accessor(:is_primary, :isPrimary)     }
  it { should alias_accessor(:service_host, :serviceHost) }
end