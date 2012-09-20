module GroupDocs
  class Signature
    #
    # Envelope and template entities share the same set of fields.
    #
    # @see GroupDocs::Signature::Envelope
    # @see GroupDocs::Signature::Template
    #
    module TemplateFields

      # @attr [String] id
      attr_accessor :id
      # @attr [String] name
      attr_accessor :name
      # @attr [Integer] ownerId
      attr_accessor :ownerId
      # @attr [String] ownerGuid
      attr_accessor :ownerGuid
      # @attr [String] reminderTime
      attr_accessor :reminderTime
      # @attr [Integer] stepExpireTime
      attr_accessor :stepExpireTime
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
      alias_method :owner_id,           :ownerId
      alias_method :owner_id=,          :ownerId=
      alias_method :owner_guid,         :ownerGuid
      alias_method :owner_guid=,        :ownerGuid=
      alias_method :reminder_time,      :reminderTime
      alias_method :reminder_time=,     :reminderTime=
      alias_method :step_expire_time,   :stepExpireTime
      alias_method :step_expire_time=,  :stepExpireTime=
      alias_method :owner_should_sign,  :ownerShouldSign
      alias_method :owner_should_sign=, :ownerShouldSign=
      alias_method :ordered_signature,  :orderedSignature
      alias_method :ordered_signature=, :orderedSignature=
      alias_method :email_subject,      :emailSubject
      alias_method :email_subject=,     :emailSubject=
      alias_method :email_body,         :emailBody
      alias_method :email_body=,        :emailBody=
      alias_method :documents_count,    :documentsCount
      alias_method :documents_count=,   :documentsCount=
      alias_method :documents_pages,    :documentsPages
      alias_method :documents_pages=,   :documentsPages=

      #
      # Converts each recipient to GroupDocs::Signature::Recipient object.
      # @param [Array<GroupDocs::Signature::Recipient>, Hash] recipients
      #
      def recipients=(recipients)
        if recipients
          @recipients = recipients.map do |recipient|
            if recipient.is_a?(GroupDocs::Signature::Recipient)
              recipient
            else
              Signature::Recipient.new(recipient)
            end
          end
        end
      end

    end # TemplateFields
  end # Signature
end # GroupDocs
