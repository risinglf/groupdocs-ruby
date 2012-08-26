module GroupDocs
  class Subscription < GroupDocs::Api::Entity

    #
    # Returns current subscription plan.
    #
    # @example
    #   GroupDocs::Subscription.current!.name
    #   #=> 'Free'
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Subscription]
    #
    def self.current!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/system/{{client_id}}/plan'
      end.execute!

      new(json)
    end

    # @attr [Integer] ref_id
    attr_accessor :ref_id
    # @attr [String] Name
    attr_accessor :Name

    # Human-readable accessors
    alias_method :name,  :Name
    alias_method :name=, :Name=

  end # Subscription
end # GroupDocs
