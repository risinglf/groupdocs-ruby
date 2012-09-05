module GroupDocs
  class Signature::Recipient < GroupDocs::Api::Entity

    # @attr [String] id
    attr_accessor :id
    # @attr [String] firstName
    attr_accessor :firstName
    # @attr [String] lastName
    attr_accessor :lastName
    # @attr [String] nickname
    attr_accessor :nickname
    # @attr [String] roleId
    attr_accessor :roleId
    # @attr [String] order
    attr_accessor :order

    # Human-readable accessors
    alias_method :role_id,  :roleId
    alias_method :role_id=, :roleId=

  end # Signature::Contact
end # GroupDocs
