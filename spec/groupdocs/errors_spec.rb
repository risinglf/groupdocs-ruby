require 'spec_helper'

describe GroupDocs::Errors::NoClientIdError do
  it { should be_a(StandardError) }
end

describe GroupDocs::Errors::NoPrivateKeyError do
  it { should be_a(StandardError) }
end

describe GroupDocs::Errors::UnsupportedMethodError do
  it { should be_a(StandardError) }
end
