module GroupDocs
  class Subscription < Api::Entity

    require 'groupdocs/subscription/limit'

    LIMITS = {
      annotations_limit:      'AnnotationsLimit',
      apicalls:               'APICalls',
      apiemails:              'APIEmails',
      assembly_limit:         'AssemblyLimit',
      branded:                'Branded',
      comparison_limit:       'ComparisonLimit',
      conversion_limit:       'ConversionLimit',
      documents_limit:        'DocumentsLimit',
      document_history_limit: 'DocumentHistoryLimit',
      document_size_limit:    'DocumentSizeLimit',
      document_tokens_limit:  'DocumentTokensLimit',
      sharing_limit:          'SharingLimit',
      signature_limit:        'SignatureLimit',
      storage_space_limit:    'StorageSpaceLimit',
      users_limit:            'UsersLimit',
    }

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

    #
    # Returns all subscription plans.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Subscription>]
    #
    def self.list!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/system/{{client_id}}/plans'
      end.execute!

      json[:metrics].map do |plan|
        new(plan)
      end
    end

    # @attr [Integer] Id
    attr_accessor :Id
    # @attr [String] Name
    attr_accessor :Name
    # @attr [Integer] PricingPlanId
    attr_accessor :PricingPlanId
    # @attr [Integer] Price
    attr_accessor :Price
    # @attr [String] CurrencyCode
    attr_accessor :CurrencyCode

    # Human-readable accessors
    alias_method :id,               :Id
    alias_method :id=,              :Id=
    alias_method :name,             :Name
    alias_method :name=,            :Name=
    alias_method :pricing_plan_id,  :PricingPlanId
    alias_method :pricing_plan_id=, :PricingPlanId=
    alias_method :price,            :Price
    alias_method :price=,           :Price=
    alias_method :currency_code,    :CurrencyCode
    alias_method :currency_code=,   :CurrencyCode=

    # Compatibility with response JSON
    alias_method :ref_id=, :id=

    #
    # Dynamically generate accessors for existing subscription plan limits.
    #
    LIMITS.each do |snake, camel|
      # @attr [GroupDocs::Subscription::Limit] limit
      attr_accessor camel

      # Human-readable accessors
      alias_method :"#{snake}",  :"#{camel}"
      alias_method :"#{snake}=", :"#{camel}="

      #
      # Converts hash to subscription plan limit.
      # @return [GroupDocs::Subscription::Limit]
      #
      define_method(snake) do
        Limit.new(instance_variable_get(:"@#{camel}"))
      end
    end

  end # Subscription
end # GroupDocs
