module GroupDocs
  class Signature::Template < Api::Entity

    include Signature::DocumentMethods
    include Signature::RecipientMethods
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
      api.add_params(nickname: recipient.nickname,
                     role:     recipient.role_id,
                     order:    recipient.order)
      api.execute!
    end

    #
    # Modify recipient of template.
    #
    # @example
    #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
    #   recipient = template.recipients!.first
    #   recipient.nickname = 'John Smith'
    #   template.modify_recipient! recipient
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def modify_recipient!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/templates/#{id}/recipient/#{recipient.id}"
      end
      api.add_params(nickname: recipient.nickname, role: recipient.role_id, order: recipient.order)
      api.execute!
    end

    #
    # Returns an array of fields for document and recipient.
    #
    # @example
    #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
    #   document = template.documents!.first
    #   recipient = template.recipients!.first
    #   template.fields! document, recipient
    #
    # @param [GroupDocs::Document] document
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if document is not GroupDocs::Document
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def fields!(document, recipient, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/{{client_id}}/templates/#{id}/fields"
      end
      api.add_params(document: document.file.guid, recipient: recipient.id)
      json = api.execute!

      json[:fields].map do |field|
        Signature::Field.new(field)
      end
    end

    #
    # Adds field for document and recipient.
    #
    # @example
    #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
    #   field = GroupDocs::Signature::Field.get!.detect { |f| f.name == "Signature" }
    #   field.location = { location_x: 0.1, location_y: 0.1, page: 1 }
    #   document = template.documents!.first
    #   recipient = template.recipients!.first
    #   template.add_field! field, document, recipient
    #
    # @param [GroupDocs::Signature::Field] field
    # @param [GroupDocs::Document] document
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
    # @raise [ArgumentError] if document is not GroupDocs::Document
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    # @raise [ArgumentError] if field does not specify location
    #
    def add_field!(field, document, recipient, access = {})
      field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
        "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"
      field.location or raise ArgumentError,
        "You have to specify field location, received: #{field.location.inspect}"

      payload = field.to_hash # field itself
      payload.merge!(field.location.to_hash) # location should added in plain view (i.e. not "location": {...})
      payload.merge!(forceNewField: true) # create new field flag

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/templates/#{id}/documents/#{document.file.guid}/recipient/#{recipient.id}/field/#{field.id}"
        request[:request_body] = payload
      end.execute!
    end

    #
    # Deletes field.
    #
    # @example
    #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
    #   document = template.documents!.first
    #   recipient = template.recipients!.first
    #   field = template.fields!(document, recipient).first
    #   template.deletes_field! field
    #
    # @param [GroupDocs::Signature::Field] field
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
    #
    def delete_field!(field, access = {})
      field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
        "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/signature/{{client_id}}/templates/#{id}/fields/#{field.id}"
      end.execute!
    end

    #
    # Modifies field location.
    #
    # @example
    #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
    #   document = template.documents!.first
    #   recipient = template.recipients!.first
    #   field = template.fields!(document, recipient).first
    #   location = field.locations.first
    #   location.x = 0.123
    #   location.y = 0.123
    #   location.page = 2
    #   template.modify_field_location! location, field, document, recipient
    #
    # @param [GroupDocs::Signature::Field::Location] location
    # @param [GroupDocs::Signature::Field] field
    # @param [GroupDocs::Document] document
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if location is not GroupDocs::Signature::Field::Location
    # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
    # @raise [ArgumentError] if document is not GroupDocs::Document
    # @raise [ArgumentError] if recipient is not GroupDocs::Signature::Recipient
    #
    def modify_field_location!(location, field, document, recipient, access = {})
      location.is_a?(GroupDocs::Signature::Field::Location) or raise ArgumentError,
        "Location should be GroupDocs::Signature::Field::Location object, received: #{location.inspect}"
      field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
        "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/templates/#{id}/documents/#{document.file.guid}/recipient/#{recipient.id}/fields/#{field.id}/locations/#{location.id}"
        request[:request_body] = location.to_hash
      end.execute!
    end

    #
    # Deletes field location.
    #
    # @example
    #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
    #   document = template.documents!.first
    #   recipient = template.recipients!.first
    #   field = template.fields!(document, recipient).first
    #   location = field.locations.first
    #   template.delete_field_location! location, field
    #
    # @param [GroupDocs::Signature::Field::Location] location
    # @param [GroupDocs::Signature::Field] field
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if location is not GroupDocs::Signature::Field::Location
    # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
    #
    def delete_field_location!(location, field, access = {})
      location.is_a?(GroupDocs::Signature::Field::Location) or raise ArgumentError,
        "Location should be GroupDocs::Signature::Field::Location object, received: #{location.inspect}"
      field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
        "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/signature/{{client_id}}/templates/#{id}/fields/#{field.id}/locations/#{location.id}"
      end.execute!
    end

  end # Signature::Template
end # GroupDocs
