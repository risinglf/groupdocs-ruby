module GroupDocs
  class Signature::Envelope < GroupDocs::Api::Entity

    require 'groupdocs/signature/template_fields'

    include Signature::TemplateFields

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

    # @attr [String] creationDateTime
    attr_accessor :creationDateTime
    # @attr [Symbol] status
    attr_accessor :status
    # @attr [String] statusDateTime
    attr_accessor :statusDateTime
    # @attr [Integer] envelopeExpireTime
    attr_accessor :envelopeExpireTime

    # Human-readable accessors
    alias_method :creation_date_time,    :creationDateTime
    alias_method :creation_date_time=,   :creationDateTime=
    alias_method :status_date_time,      :statusDateTime
    alias_method :status_date_time=,     :statusDateTime=
    alias_method :envelope_expire_time,  :envelopeExpireTime
    alias_method :envelope_expire_time=, :envelopeExpireTime=

  end # Signature::Envelope
end # GroupDocs
