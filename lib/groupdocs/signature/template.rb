module GroupDocs
  class Signature::Template < GroupDocs::Api::Entity

    require 'groupdocs/signature/template_fields'

    include Signature::TemplateFields

    #
    # Returns a list of all templates.
    #
    # @param [Hash] options Hash of options
    # @option options [Integer] :page Page to start with
    # @option options [Integer] :records How many items to list
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Template>]
    #
    def self.all!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/templates'
      end
      api.add_params(options)
      json = api.execute!

      json[:templates].map do |template|
        new(template)
      end
    end

    #
    # Returns template by its identifier.
    #
    # @param [String] id
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Signature::Template]
    #
    def self.get!(id, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/{{client_id}}/templates/#{id}"
      end.execute!

      new(json[:template])
    end

    # @attr [Integer] templateExpireTime
    attr_accessor :templateExpireTime

    # Human-readable accessors
    alias_method :template_expire_time,  :templateExpireTime
    alias_method :template_expire_time=, :templateExpireTime=

    #
    # Creates template.
    #
    # @example
    #   template = GroupDocs::Signature::Template.new
    #   template.name = "Envelope Template"
    #   template.email_subject = "Sing this!"
    #   template.create!
    #
    # @param [Hash] options Hash of options
    # @option options [Integer] :templateId Template GUID to use
    # @option options [Integer] :envelopeId Envelope GUID to use
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/template'
        request[:request_body] = to_hash
      end
      api.add_params(options.merge(name: name))
      json = api.execute!

      self.id = json[:template][:id]
    end

    #
    # Modifies template.
    #
    # @example
    #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
    #   template.name = "Envelope Template"
    #   template.email_subject = "Sing this!"
    #   template.modify!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def modify!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/templates/#{id}"
        request[:request_body] = to_hash
      end.execute!
    end

    #
    # Renames template.
    #
    # @param [String] name New template name
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def rename!(name, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        # TODO fix typo in API
        request[:path] = "/signature/{{client_id}}/tempalates/#{id}"
      end
      api.add_params(name: name)
      api.execute!

      self.name = name
    end

    #
    # Deletes template.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def delete!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/signature/{{client_id}}/templates/#{id}"
      end.execute!
    end

    #
    # Returns recipients array of template.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Recipient>]
    #
    def recipients!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/{{client_id}}/templates/#{id}/recipients"
      end.execute!

      json[:recipients].map do |recipient|
        Signature::Recipient.new(recipient)
      end
    end

    #
    # Adds recipient to template.
    #
    # @example
    #   roles = GroupDocs::Signature::Role.get!
    #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
    #   recipient = GroupDocs::Signature::Recipient.new
    #   recipient.nickname = 'John Smith'
    #   recipient.role_id = roles.detect { |role| role.name == "Signer" }.id
    #   template.add_recipient! recipient
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def add_recipient!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/templates/#{id}/recipient"
      end
      api.add_params(nickname: recipient.nickname, role: recipient.role_id, order: recipient.order)
      api.execute!
    end

    #
    # Removes recipient from template.
    #
    # @example
    #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
    #   recipient = template.recipients!.first
    #   template.remove_recipient! recipient
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def remove_recipient!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/signature/{{client_id}}/templates/#{id}/recipients/#{recipient.id}"
      end.execute!
    end

  end # Signature::Template
end # GroupDocs
