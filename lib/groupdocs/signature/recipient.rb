module GroupDocs
  class Signature::Recipient < Api::Entity

    # @attr [String] id
    attr_accessor :id
    # @attr [String] email
    attr_accessor :email
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
    alias_method :first_name,  :firstName
    alias_method :first_name=, :firstName=
    alias_method :last_name,   :lastName
    alias_method :last_name=,  :lastName=
    alias_method :role_id,     :roleId
    alias_method :role_id=,    :roleId=

  end # Signature::Contact
end # GroupDocs
