module GroupDocs
  class Signature < Api::Entity

    require 'groupdocs/signature/shared'
    require 'groupdocs/signature/contact'
    require 'groupdocs/signature/envelope'
    require 'groupdocs/signature/field'
    require 'groupdocs/signature/form'
    require 'groupdocs/signature/list'
    require 'groupdocs/signature/recipient'
    require 'groupdocs/signature/role'
    require 'groupdocs/signature/template'

    include Api::Helpers::MIME

    #
    # Returns a list of all user signatures.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature>]
    #
    def self.get!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/signatures'
      end.execute!

      json[:signatures].map do |signature|
        new(signature)
      end
    end


    #
    # Fill in envelope field.
    #
    # @param [String] envelope Envelope GUID
    # @param [String] document Document GUID
    # @param [String] recipient Recipient GUID
    # @param [String] field Field GUID
    # @param [Hash] post_data Data to be placed in field
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def fill_envelope!(envelope, document, recipient, field, post_data, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/public/envelopes/#{envelope.guid}/documents/#{document.guid}/recipient/#{recipient.guid}/field/#{field.guid}"
        request[:request_body] = post_data
      end.execute!

      json[:field]
    end

    #
    # Sing envelope
    #
    # @param [String] envelope Envelope GUID
    # @param [String] recipient Recipient GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def sign_envelope!(envelope, recipient, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/public/envelopes/#{envelope.guid}/recipient/#{recipient.id}/sign"
      end.execute!
    end

    #
    # Sing envelope
    #
    # @param [String] envelope Envelope GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def recipient!(envelope, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/envelopes/#{envelope.guid}/recipient/"
      end.execute!

      json[:recipient]
    end

    #
    # Get signature field for document in envelope per recipient.
    #
    # @param [String] envelope Envelope GUID
    # @param [Hash] options
    # @option options [String] :document Document GUID
    # @option options [String] :recipient Recipient GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def field_envelope_recipient!(envelope, options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/envelopes/#{envelope.guid}/fields"
      end
      api.add_params(options)
      json = api.execute!

      json[:field]
    end

    #
    # Get signed envelope field data.
    #
    # @param [String] envelope Envelope GUID
    # @param [String] recipient Recipient GUID
    # @param [String] field Field GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def field_envelope_date!(envelope, recipient, field,access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/envelopes/#{envelope.guid}/fields/recipient/#{recipient.id}/field/#{field.id}"
      end.execute!

    end

    #
    # Get signature envelope.
    #
    # @param [String] envelope Envelope GUID
    # @param [String] recipient Recipient GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def get_sign_envelope!(envelope, recipient, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/envelopes/#{envelope.guid}/recipient/#{recipient.id}"
      end.execute!

      json[:envelope]
    end

    #
    # Get signature envelope.
    #
    # @param [String] envelope Envelope GUID
    # @param [String] recipient Recipient GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def get_signed_documents!(envelope, recipient, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/envelopes/#{envelope.guid}/recipient/#{recipient.id}/documents/get"
      end.execute!
    end

    #
    # Get signature envelope.
    #
    # @param [String] form Form GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def fill_signature_form!(form, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/forms/#{form.id}/fill"
      end.execute!

      json[:participant]
    end

    #
    # Fill form field.
    #
    # @param [String] form Form GUID
    # @param [String] document Document GUID
    # @param [String] participant Participant GUID
    # @param [String] field Field GUID
    # @param [String] authentication Authentication signature
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def fill_form_field!(form, document, participant, field, authentication, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/public/forms/#{form.id}/documents/#{document.guid}/participant/#{participant.id}/field/#{field.id}"
      end
      api.add_params(:participantAuthSignature => authentication)
      json = api.execute!

      json[:field]
    end

    #
    # Sign form.
    #
    # @param [String] form Form GUID
    # @param [String] participant Participant GUID
    # @param [String] authentication Authentication signature
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def sign_form!(form, participant, authentication, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/signature/public/forms/#{form}/participant/#{participant}/sign"
      end
      api.add_params(:participantAuthSignature => authentication)
      json = api.execute!

      json[:field]
    end

    #
    #  Get form fields for document in form per participant
    #
    # @param [String] form Form GUID
    # @param [Hash] options
    # @option [String] document Document GUID
    # @option [String] participant Participant GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def get_sign_form!(form, options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/forms/#{form.id}/fields"
      end
      api.add_params(options)
      json = api.execute!

      json[:field]
    end

    #
    # Get signed form documents.
    #
    # @param [String] form Form GUID
    # @param [String] participant Participant GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def get_signed_documents_form!(path, name, form, participant, access = {})
      response = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/forms/#{form.id}/participant/#{participant.id}/documents/get"
      end.execute!

      filepath = "#{path}/#{name}."
      Object::File.open(filepath, 'wb') do |file|
        file.write(response)
      end

      filepath
    end

    #
    # Get signature form participant.
    #
    # @param [String] form Form GUID
    # @param [String] participant Participant GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def get_sign_form_participant!(form, participant, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/forms/#{form}/participant/#{participant}"
      end.execute!

      json[:participant]
    end

    #
    #  Sign document
    #
    # @param [String] document Document GUID
    # @param [Hash] settings Settings of the signing document
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def sign_document!(document, settings = {}, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/public/documents/#{document.guid}/sign"
        request[:request_body] = settings
      end.execute!

      json[:jobId]
    end
	
	 #
    #  Get document fields
    #
    # @param [String] document Document GUID
    # @param [Hash] settings Settings of the signing document
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def self.get_document_fields!(document, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/documents/#{document}/fields"
      end.execute!
    end

    #
    #  Verify to document
    #
    # @param [String] path Path to document GUID
    # @param [Hash] settings Settings of the signing document
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def self.verify!(path, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/public/verify"
        request[:request_body] = path
      end.execute!
    end

    #
    #  Sign document
    #
    # @param [String] job Job GUID
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array]
    #
    def self.sign_document_status!(job, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/documents/#{job}/status"
      end.execute!

      Storage::File.new(:guid => json[:documents][0][:documentId])
    end



    #
    # Returns a list of all signatures for recipient.
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature>]
    #
    def self.get_for_recipient!(recipient, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/public/signatures'
      end
      api.add_params(:recipientId => recipient.id)
      json = api.execute!

      json[:signatures].map do |signature|
        new(signature)
      end
    end

    # @attr [String] id
    attr_accessor :id
    # @attr [String] userGuid
    attr_accessor :userGuid
    # @attr [String] recipientId
    attr_accessor :recipientId
    # @attr [String] name
    attr_accessor :name
    # @attr [String] companyName
    attr_accessor :companyName
    # @attr [String] position
    attr_accessor :position
    # @attr [String] firstName
    attr_accessor :firstName
    # @attr [String] lastName
    attr_accessor :lastName
    # @attr [String] fullName
    attr_accessor :fullName
    # @attr [String] textInitials
    attr_accessor :textInitials
    # @attr [String] signatureImageFileId
    attr_accessor :signatureImageFileId
    # @attr [String] initialsImageFileId
    attr_accessor :initialsImageFileId
    # @attr [String] signatureImageUrl
    attr_accessor :signatureImageUrl
    # @attr [String] initialsImageUrl
    attr_accessor :initialsImageUrl
    # @attr [String] signatureData
    attr_accessor :signatureData
    # @attr [String] initialsData
    attr_accessor :initialsData
    # @attr [String] createdTimeStamp
    attr_accessor :createdTimeStamp
    # @attr [String] image_path
    attr_accessor :image_path

    # Human-readable accessors
    alias_accessor :user_guid,               :userGuid
    alias_accessor :recipient_id,            :recipientId
    alias_accessor :company_name,            :companyName
    alias_accessor :first_name,              :firstName
    alias_accessor :last_name,               :lastName
    alias_accessor :full_name,               :fullName
    alias_accessor :text_initials,           :textInitials
    alias_accessor :signature_image_file_id, :signatureImageFileId
    alias_accessor :initials_image_file_id,  :initialsImageFileId
    alias_accessor :signature_image_url,     :signatureImageUrl
    alias_accessor :initials_image_url,      :initialsImageUrl
    alias_accessor :signature_data,          :signatureData
    alias_accessor :initials_data,           :initialsData
    alias_accessor :created_time_stamp,      :createdTimeStamp

    #
    # Creates signature.
    #
    # @example
    #   signature = GroupDocs::Signature.new
    #   signature.first_name = 'John'
    #   signature.last_name = 'Smith'
    #   signature.create! "John Smith's Signature"
    #
    # @param [String] title Signature title
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create!(title, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/signature'
        request[:request_body] = to_hash
      end
      api.add_params(:name => title)
      json = api.execute!

      self.id = json[:signature][:id]
    end

    #
    # Creates signature for recipient.
    #
    # @param [GroupDocs::Signature::Recipient] recipient
    # @param [String] title Signature title
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create_for_recipient!(recipient, title, access = {})
      recipient.is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
        "Recipient should be GroupDocs::Signature::Recipient object, received: #{recipient.inspect}"

      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/public/signature'
        request[:request_body] = to_hash
      end
      api.add_params(:name => title, :recipientId => recipient.id)
      json = api.execute!

      self.id = json[:signature][:id]
    end

    #
    # Deletes signature.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def delete!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/signature/{{client_id}}/signatures/#{id}"
      end.execute!
    end

    #
    # Returns signature data.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def signature_data!(access = {})
      self.signature_data = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/signatures/signature/#{id}/signatureData"
      end.execute!
    end

    #
    # Returns initials data.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def initials_data!(access = {})
      self.initials_data = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/signature/public/signatures/signature/#{id}/initialsData"
      end.execute!
    end

  end # Signature
end # GroupDocs
