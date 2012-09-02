module GroupDocs
  module Signature
    class Envelope < GroupDocs::Api::Entity

      #
      # Returns a list of all envelopes.
      #
      # @param [Hash] options Hash of options
      # @option options [Integer] :page Page to start with
      # @option options [Integer] :records How many items to list
      # @option options [Integer] :statusId Filter by status identifier
      # @option options [String] :recipient Filter by recipient email
      # @option options [String] :date Filter by date
      # @option options [String] :name Filter by name
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Signature::Envelope>]
      #
      def self.all!(options = {}, access = {})
        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = '/signature/{{client_id}}/envelopes'
        end
        api.add_params(options)
        json = api.execute!

        json[:envelopes].map do |envelope|
          new(envelope)
        end
      end

      #
      # Returns a list of all envelopes where user is recipient.
      #
      # @param [Hash] options Hash of options
      # @option options [Integer] :page Page to start with
      # @option options [Integer] :records How many items to list
      # @option options [Integer] :statusId Filter by status identifier
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Signature::Envelope>]
      #
      def self.for_me!(options = {}, access = {})
        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = '/signature/{{client_id}}/envelopes/recipient'
        end
        api.add_params(options)
        json = api.execute!

        json[:envelopes].map do |envelope|
          new(envelope)
        end
      end

      #
      # Returns an envelope by its identifier.
      #
      # @param [String] id
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [GroupDocs::Signature::Envelope]
      #
      def self.get!(id, access = {})
        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = "/signature/{{client_id}}/envelopes/#{id}"
        end.execute!

        new(json[:envelope])
      end

      # @attr [String] id
      attr_accessor :id
      # @attr [String] name
      attr_accessor :name
      # @attr [Integer] ownerId
      attr_accessor :ownerId
      # @attr [String] ownerGuid
      attr_accessor :ownerGuid
      # @attr [String] creationDateTime
      attr_accessor :creationDateTime
      # @attr [Symbol] status
      attr_accessor :status
      # @attr [String] statusDateTime
      attr_accessor :statusDateTime
      # @attr [String] reminderTime
      attr_accessor :reminderTime
      # @attr [Integer] stepExpireTime
      attr_accessor :stepExpireTime
      # @attr [Integer] envelopeExpireTime
      attr_accessor :envelopeExpireTime
      # @attr [Boolean] ownerShouldSign
      attr_accessor :ownerShouldSign
      # @attr [Boolean] orderedSignature
      attr_accessor :orderedSignature
      # @attr [String] emailSubject
      attr_accessor :emailSubject
      # @attr [String] emailBody
      attr_accessor :emailBody
      # @attr [Integer] documentsCount
      attr_accessor :documentsCount
      # @attr [Integer] documentsPages
      attr_accessor :documentsPages
      # @attr [Array<GroupDocs::Signature::Contact>] recipients
      attr_accessor :recipients

      # Human-readable accessors
      alias_method :owner_id,              :ownerId
      alias_method :owner_id=,             :ownerId=
      alias_method :owner_guid,            :ownerGuid
      alias_method :owner_guid=,           :ownerGuid=
      alias_method :creation_date_time,    :creationDateTime
      alias_method :creation_date_time=,   :creationDateTime=
      alias_method :status_date_time,      :statusDateTime
      alias_method :status_date_time=,     :statusDateTime=
      alias_method :reminder_time,         :reminderTime
      alias_method :reminder_time=,        :reminderTime=
      alias_method :step_expire_time,      :stepExpireTime
      alias_method :step_expire_time=,     :stepExpireTime=
      alias_method :envelope_expire_time,  :envelopeExpireTime
      alias_method :envelope_expire_time=, :envelopeExpireTime=
      alias_method :owner_should_sign,     :ownerShouldSign
      alias_method :owner_should_sign=,    :ownerShouldSign=
      alias_method :ordered_signature,     :orderedSignature
      alias_method :ordered_signature=,    :orderedSignature=
      alias_method :email_subject,         :emailSubject
      alias_method :email_subject=,        :emailSubject=
      alias_method :email_body,            :emailBody
      alias_method :email_body=,           :emailBody=
      alias_method :documents_count,       :documentsCount
      alias_method :documents_count=,      :documentsCount=
      alias_method :documents_pages,       :documentsPages
      alias_method :documents_pages=,      :documentsPages=

      #
      # Converts each recipient to GroupDocs::Signature::Contact object.
      #
      # @param [Array<GroupDocs::Signature::Contact, Hash>] recipients
      #
      def recipients=(recipients)
        if recipients
          @recipients = recipients.map do |recipient|
            if recipient.is_a?(GroupDocs::Signature::Contact)
              recipient
            else
              Signature::Contact.new(recipient)
            end
          end
        end
      end

    end # Envelope
  end # Signature
end # GroupDocs
