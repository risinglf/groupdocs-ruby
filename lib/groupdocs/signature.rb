module GroupDocs
  class Signature < GroupDocs::Api::Entity

    require 'groupdocs/signature/contact'
    require 'groupdocs/signature/envelope'
    require 'groupdocs/signature/list'

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
    # @attr [String] createdTimeStamp
    attr_accessor :createdTimeStamp

    # Human-readable accessors
    alias_method :user_guid,                :userGuid
    alias_method :user_guid=,               :userGuid=
    alias_method :recipient_id,             :recipientId
    alias_method :recipient_id=,            :recipientId=
    alias_method :company_name,             :companyName
    alias_method :company_name=,            :companyName=
    alias_method :first_name,               :firstName
    alias_method :first_name=,              :firstName=
    alias_method :last_name,                :lastName
    alias_method :last_name=,               :lastName=
    alias_method :full_name,                :fullName
    alias_method :full_name=,               :fullName=
    alias_method :text_initials,            :textInitials
    alias_method :text_initials=,           :textInitials=
    alias_method :signature_image_file_id,  :signatureImageFileId
    alias_method :signature_image_file_id=, :signatureImageFileId=
    alias_method :initials_image_file_id,   :initialsImageFileId
    alias_method :initials_image_file_id=,  :initialsImageFileId=
    alias_method :signature_image_url,      :signatureImageUrl
    alias_method :signature_image_url=,     :signatureImageUrl=
    alias_method :initials_image_url,       :initialsImageUrl
    alias_method :initials_image_url=,      :initialsImageUrl=
    alias_method :created_time_stamp,       :createdTimeStamp
    alias_method :created_time_stamp=,      :createdTimeStamp=

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
      api.add_params(name: title)
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
    # TODO: fix this in API
    rescue RestClient::BadRequest
      nil
    end

  end # Signature
end # GroupDocs