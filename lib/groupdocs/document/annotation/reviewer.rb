module GroupDocs
  class Document::Annotation::Reviewer < Api::Entity

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

    # @attr [String] emailAddress
    attr_accessor :emailAddress
    # @attr [String] FullName
    attr_accessor :FullName

    # Human-readable accessors
    alias_method :email_address,  :emailAddress
    alias_method :email_address=, :emailAddress=
    alias_method :full_name,      :FullName
    alias_method :full_name=,     :FullName=

    #
    # Adds new reviewer contact.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def add!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = '/ant/{{client_id}}/reviewerContacts'
        request[:request_body] = [to_hash] + self.class.all!.map(&:to_hash)
      end.execute!
    end

  end # Document::Annotation::Reviewer
end # GroupDocs
