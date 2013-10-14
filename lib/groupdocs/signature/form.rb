module GroupDocs
  class Signature::Form < Api::Entity

    include Api::Helpers::SignaturePublic
    include Signature::EntityMethods
    include Signature::DocumentMethods
    include Signature::FieldMethods
    extend  Signature::ResourceMethods

    # form doesn't have recipients
    undef_method :assign_field!

    STATUSES = {
      :draft       => -1,
      :in_progress =>  1,
      :completed   =>  2,
      :archived    =>  3,
    }

    #
    # Returns a list of all forms.
    #
    # @param [Hash] options Hash of options
    # @option options [Integer] :page Page to start with
    # @option options [Integer] :records How many items to list
    # @option options [Integer] :status_id Filter by status identifier
    # @option options [String] :document Filter by document GUID
    # @option options [String] :date Filter by date
    # @option options [String] :name Filter by name
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Envelope>]
    #
    def self.all!(options = {}, access = {})
      status_id = options.delete(:status_id)
      options[:statusId] = status_id if status_id

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/forms'
      end
      api.add_params(options)
      json = api.execute!

      json[:forms].map do |form|
        new(form)
      end
    end

    #
    # Returns form by its identifier.
    #
    # @param [String] id
    # @param [Hash] options
    # @option options [Boolean] :public Defaults to false
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Signature::Form]
    #
    def self.get!(id, options = {}, access = {})
      if options[:public]
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/signature/public/forms/#{id}"
        end.execute!

        new(json[:form])
      else
        super(id, access)
      end
    end

    # @attr [String] id
    attr_accessor :id
    # @attr [String] name
    attr_accessor :name
    # @attr [String] ownerGuid
    attr_accessor :ownerGuid
    # @attr [String] templateGuid
    attr_accessor :templateGuid
    # @attr [String] createdTimeStamp
    attr_accessor :createdTimeStamp
    # @attr [String] statusDateTime
    attr_accessor :statusDateTime
    # @attr [Integer] documentsCount
    attr_accessor :documentsCount
    # @attr [Integer] documentsPages
    attr_accessor :documentsPages
    # @attr [Integer] participantsCount
    attr_accessor :participantsCount
    # @attr [Array] fieldsInFinalFileName
    attr_accessor :fieldsInFinalFileName
    # @attr [Boolean] canParticipantDownloadForm
    attr_accessor :canParticipantDownloadForm
    # @attr [Symbol] status
    attr_accessor :status
    # @attr [String] waterMarkText
    attr_accessor :waterMarkText
    # @attr [String] waterMarkImage
    attr_accessor :waterMarkImage
    # @attr [Boolean] notifyOwnerOnSign
    attr_accessor :notifyOwnerOnSign


    # Human-readable accessors
    alias_accessor :owner_guid,                    :ownerGuid
    alias_accessor :template_guid,                 :templateGuid
    alias_accessor :created_time_stamp,            :createdTimeStamp
    alias_accessor :status_date_time,              :statusDateTime
    alias_accessor :documents_count,               :documentsCount
    alias_accessor :documents_pages,               :documentsPages
    alias_accessor :participants_count,            :participantsCount
    alias_accessor :can_participant_download_form, :canParticipantDownloadForm
    alias_accessor :water_mark_text,               :waterMarkText
    alias_accessor :water_mark_image,              :waterMarkImage
    alias_accessor :notifyOwnerOnSign,             :notifyOwnerOnSign


    #
    # Converts status to human-readable format.
    # @return [Symbol]
    #
    def status
      STATUSES.invert[@status]
    end

    #
    # Converts array of field names to machine-readable format.
    # @param [Array<String>] fields
    #
    def fields_in_final_file_name=(fields)
      if fields.is_a?(Array)
        fields = fields.join(',')
      end

      @fieldsInFinalFileName = fields
    end

    #
    # Converts field names to human-readable format.
    # @return [Array<String>]
    #
    def fields_in_final_file_name
      @fieldsInFinalFileName.split(',') if @fieldsInFinalFileName
    end

    #
    # Creates form.
    #
    # @example
    #   form = GroupDocs::Signature::Form.new
    #   form.name = "Form"
    #   form.create! template
    #
    # @param [Hash] options Hash of options
    # @option options [String] :template_id Template GUID to create form from
    # @option options [Integer] :assembly_id Questionnaire identifier to create form from
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if template is not GroupDocs::Signature::Template
    #
    def create!(options = {}, access = {})
      #template_id = options.delete(:template_id)
      #assembly_id = options.delete(:assembly_id)
      #options[:templateId] = template_id if template_id
      #options[:assemblyId] = assembly_id if assembly_id

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/form'
        request[:request_body] = to_hash

      end

      api.add_params(options.merge(:name => name))
      json = api.execute!

      self.id = json[:form][:id]
    end

    #
    # Returns documents array.
    #
    # @param [Hash] options
    # @option options [Boolean] :public Defaults to false
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document>]
    #
    def documents!(options = {}, access = {})
      client_id = client_id(options[:public])

      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/#{client_id}/forms/#{id}/documents"
      end.execute!

      json[:documents].map do |document|
        id = document[:documentId] || document[:id]
        file = Storage::File.new(:guid => id, :name => document[:name])
        Document.new(document.merge(:file => file))
      end
    end

    #
    # Publishes form.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @param callbackUrl [String]:callbackUrl  Webhook Callback Url
    #
    def publish!(callbackUrl, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/forms/#{id}/publish"
        request[:request_body] = callbackUrl
      end.execute!
    end

    #
    # Completes form.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def complete!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/forms/#{id}/complete"
      end.execute!
    end

    #
    # Archives completed form.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def archive!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/forms/#{id}/archive"
      end.execute!
    end

    #
    # Returns an array of fields for document per participant.
    #
    # @param [GroupDocs::Document] document
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if document is not GroupDocs::Document
    #
    def fields!(document, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"

      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/{{client_id}}/forms/#{id}/documents/#{document.file.guid}/fields"
      end.execute!

      json[:fields].map do |field|
        Signature::Field.new(field)
      end
    end

    #
    # Adds field for document.
    #
    # @example
    #   form = GroupDocs::Signature::Form.get!("g94h5g84hj9g4gf23i40j")
    #   field = GroupDocs::Signature::Field.get!.detect { |f| f.type == :signature }
    #   field.location = { location_x: 0.1, location_y: 0.1, page: 1 }
    #   document = form.documents!.first
    #   form.add_field! field, document
    #
    # @param [GroupDocs::Signature::Field] field
    # @param [GroupDocs::Document] document
    # @param [Hash] options
    # @option options [Boolean] :force_new_field Set to true to force new field create
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
    # @raise [ArgumentError] if document is not GroupDocs::Document
    # @raise [ArgumentError] if field does not specify location
    #
    def add_field!(field, document, opts = {}, access = {})
      field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
        "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"
      field.location or raise ArgumentError,
        "You have to specify field location, received: #{field.location.inspect}"

      opts[:force_new_field] = true if opts[:force_new_field].nil?
      payload = field.to_hash # field itself
      payload.merge!(field.location.to_hash) # location should added in plain view (i.e. not "location": {...})
      payload.merge!(:forceNewField => opts[:force_new_field]) # create new field flag

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/forms/#{id}/documents/#{document.file.guid}/field/#{field.id}"
        request[:request_body] = payload
      end.execute!
    end

    #
    # Modifies field location.
    #
    # @example Modify field location in template
    #   form = GroupDocs::Signature::Form.get!("g94h5g84hj9g4gf23i40j")
    #   document = form.documents!.first
    #   field = form.fields!(document).first
    #   location = field.locations.first
    #   location.x = 0.123
    #   location.y = 0.123
    #   location.page = 2
    #   form.modify_field_location! location, field, document
    #
    # @param [GroupDocs::Signature::Field::Location] location
    # @param [GroupDocs::Signature::Field] field
    # @param [GroupDocs::Document] document
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if location is not GroupDocs::Signature::Field::Location
    # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
    # @raise [ArgumentError] if document is not GroupDocs::Document
    #
    def modify_field_location!(location, field, document, recipient, access = {})
      location.is_a?(GroupDocs::Signature::Field::Location) or raise ArgumentError,
        "Location should be GroupDocs::Signature::Field::Location object, received: #{location.inspect}"
      field.is_a?(GroupDocs::Signature::Field) or raise ArgumentError,
        "Field should be GroupDocs::Signature::Field object, received: #{field.inspect}"
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
        "Document should be GroupDocs::Document object, received: #{document.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/forms/#{id}/documents/#{document.file.guid}/fields/#{field.id}/locations/#{location.id}"
        request[:request_body] = location.to_hash
      end.execute!
    end

    #
    # Updates form adding fields from template.
    #
    # @param [GroupDocs::Signature::Template] template
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if template is not GroupDocs::Signature::Template
    #
    def update_from_template!(template, access = {})
      template.is_a?(GroupDocs::Signature::Template) or raise ArgumentError,
        "Template should be GroupDocs::Signature::Template object, received: #{template.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/forms/#{form.id}/templates/#{template.id}"
      end.execute!
    end

    #
    # Modify signature form document
    #
    # @example
    #   form = GroupDocs::Signature::Form.get!("g94h5g84hj9g4gf23i40j")
    #   document = envelope.documents!.first
    #   recipient = envelope.recipients!.first
    #   field = envelope.fields!(document, recipient).first
    #   field.name = "Field"
    #   envelope.modify_field! field, document
    #
    #
    # @param [GroupDocs::Document] document
    # @param [Hash] options
    # @option options [Integer] Order
    # @option options [String] newDocumentGuid
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @raise [ArgumentError] if document is not GroupDocs::Document
    #
    def modify_form_document!(document, options = {}, access = {})
      document.is_a?(GroupDocs::Document) or raise ArgumentError,
                                                   "Document should be GroupDocs::Document object, received: #{document.inspect}"

      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/{{client_id}}/forms/#{form}/document/#{document.file.guid}/"
        request[:request_body] = options
      end.execute!
    end

  end # Signature::Form
end # GroupDocs
