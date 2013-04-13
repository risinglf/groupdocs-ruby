module GroupDocs
  class Signature::Role < Api::Entity

    #
    # Returns array of predefined roles.
    #
    # @param [Hash] options Hash of options
    # @option options [String] :id Filter by identifier
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::role>]
    #
    def self.get!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/roles'
      end
      api.add_params(options)
      json = api.execute!

      json[:roles].map do |role|
        new(role)
      end
    end

    # @attr [String] id
    attr_accessor :id
    # @attr [String] name
    attr_accessor :name
    # @attr [Integer] canEdit
    attr_accessor :canEdit
    # @attr [Integer] canSign
    attr_accessor :canSign
    # @attr [Integer] canAnnotate
    attr_accessor :canAnnotate
    # @attr [Integer] canDelegate
    attr_accessor :canDelegate

    # Human-readable accessors
    alias_accessor :can_edit,     :canEdit
    alias_accessor :can_sign,     :canSign
    alias_accessor :can_annotate, :canAnnotate
    alias_accessor :can_delegate, :canDelegate

    # Boolean methods for Ruby DSL
    alias_method :can_edit?,     :can_edit
    alias_method :can_sign?,     :can_sign
    alias_method :can_annotate?, :can_annotate
    alias_method :can_delegate?, :can_delegate

  end # Signature::Role
end # GroupDocs
