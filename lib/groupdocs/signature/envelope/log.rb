module GroupDocs
  class Signature::Envelope::Log < Api::Entity

    # @attr [String] id
    attr_accessor :id
    # @attr [String] date
    attr_accessor :date
    # @attr [String] userName
    attr_accessor :userName
    # @attr [String] action
    attr_accessor :action
    # @attr [String] remoteAddress
    attr_accessor :remoteAddress

    # Human-readable accessors
    alias_method :remote_address,  :remoteAddress
    alias_method :remote_address=, :remoteAddress=
    alias_method :user_name,       :userName
    alias_method :user_name=,      :userName=

  end # Signature::Envelope::Log
end # GroupDocs
