module GroupDocs
  class Document::Annotation::Reviewer < Api::Entity

    include Api::Helpers::AccessRights

    #
    # Returns all reviewer contacts.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Document::Annotation::Reviewer>]
    #
    def self.all!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/ant/{{client_id}}/contacts'
      end.execute!

      json[:reviewerContacts].map do |reviewer|
        new(reviewer)
      end
    end

    #
    # Sets reviewer contacts to passed array.
    #
    # Please, note that it removes existing reviewer contacts.
    #
    # @example Add new reviewer contact
    #   reviewers = GroupDocs::Document::Annotation::Reviewer.all!
    #   reviewers << GroupDocs::Document::Annotation::Reviewer.new(full_name: 'John Smith', email_address: 'john@smith.com')
    #   GroupDocs::Document::Annotation::Reviewer.set! reviewers
    #
    # @param [Array<GroupDocs::Document::Annotation::Reviewer>] reviewers
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def self.set!(reviewers, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = '/ant/{{client_id}}/reviewerContacts'
        request[:request_body] = reviewers.each.map(&:to_hash)
      end.execute!
    end

    # @attr [Integer] id
    attr_accessor :id
    # @attr [String] guid
    attr_accessor :guid
    # @attr [Integer] color
    attr_accessor :color
    # @attr [String] emailAddress
    attr_accessor :emailAddress
    # @attr [String] FullName
    attr_accessor :FullName
    # @attr [Array<Symbol>] accessRights
    attr_accessor :accessRights
    # @attr [String] customEmailMessage
    attr_accessor :customEmailMessage

    # Human-readable accessors
    alias_method :email_address,         :emailAddress
    alias_method :email_address=,        :emailAddress=
    alias_method :full_name,             :FullName
    alias_method :full_name=,            :FullName=
    alias_method :custom_email_message,  :customEmailMessage
    alias_method :custom_email_message=, :customEmailMessage=

    #
    # Converts access rights to human-readable format flag.
    # @return [Array<Symbol>]
    #
    def access_rights
      convert_byte_to_access_rights @accessRights
    end

    #
    # Converts access rights to machine-readable format flag.
    # @param [Array<Symbol>] rights
    #
    def access_rights=(rights)
      @accessRights = convert_access_rights_to_byte(rights)
    end

  end # Document::Annotation::Reviewer
end # GroupDocs
