module GroupDocs
  class Subscription < Api::Entity

    require 'groupdocs/subscription/limit'

    LIMITS = {
      :annotations_limit       => 'AnnotationsLimit',
      :apicalls                => 'APICalls',
      :apiemails               => 'APIEmails',
      :assembly_limit          => 'AssemblyLimit',
      :branded                 => 'Branded',
      :comparison_limit        => 'ComparisonLimit',
      :conversion_limit        => 'ConversionLimit',
      :documents_limit         => 'DocumentsLimit',
      :document_history_limit  => 'DocumentHistoryLimit',
      :document_size_limit     => 'DocumentSizeLimit',
      :document_tokens_limit   => 'DocumentTokensLimit',
      :sharing_limit           => 'SharingLimit',
      :signature_limit         => 'SignatureLimit',
      :storage_space_limit     => 'StorageSpaceLimit',
      :users_limit             => 'UsersLimit',
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
    # Simulate Assess For Pricing Plan.
    #
    # @param [String] discount_code Discount code
    # @param [String] plan_id Subscription Plan Id
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array] Invoices
    #
    def self.invoices!(discount_code, plan_id, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/system/{{client_id}}/plans/#{plan_id}/discounts/#{discount_code}"
      end.execute!

      json[:invoices]
    end

    #
    # Returns user subscription plan.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Subscription]
    #
    def self.subscription!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/system/{{client_id}}/subscription'
      end.execute!
    end

    #
    # Set subscription plan user plan.
    # @param [Hash] plan Subscription Plan Info
    # @param [String] product_id
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Subscription]
    #
    def self.set_subscription!(plan, product_id, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :PUT
        request[:path] = "/system/{{client_id}}/subscriptions/#{product_id}"
        request[:request_body] = plan
      end.execute!
    end

    #
    # Set subscription plan user plan.
    # @param [Hash] plan Update Subscription Plan Info
    # @param [String] product_id
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Subscription]
    #
    def self.update_subscription!(plan, product_id, access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/system/{{client_id}}/subscriptions/#{product_id}"
        request[:request_body] = plan
      end.execute!
    end

    #
    # Returns countries.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Subscription]
    #
    def self.get_countries!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/system/{{client_id}}/countries'
      end.execute!

      json[:countries]
    end

    #
    # Returns states.
    #
    # @param [String] name Country name
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Subscription]
    #
    def self.get_states!(name, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/system/{{client_id}}/countries/#{name}/states"
      end.execute!

      json[:states]
    end

    #
    # Set user billing address.
    #
    # @param [Hash] billing Billing address info
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [GroupDocs::Subscription]
    #
    def self.set_billing!(billing = {}, access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/system/{{client_id}}/billingaddress"
        request[:request_body] = billing
      end.execute!

      json[:billing_address]
    end

    #
    # Get invoices.
    #
    # @param [Hash] options
    # @option options [String] :pageNumber
    # @option options [String] :pageSize
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array] Invoices
    #
    def self.get_invoices!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/system/{{client_id}}/invoices"
      end
      api.add_params(options)
      json = api.execute!

      json[:invoices]
    end

    #
    # Get subscription plans.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def self.get_plans!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/system/{{client_id}}/usage"
      end
    end

    #
    # Returns purchase wizard info from billing provider.
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [String] Url
    #
    def self.get_wizard!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/system/{{client_id}}/purchase/wizard"
      end

     json[:url]
    end




    #
    # Changed in realise 1.5.8
    #
    # Returns all subscription plans for family.
    #
    # @param [Boolean] invalidate
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Subscription>]
    #
    def self.list!(invalidate, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/system/{{client_id}}/plans/groupdocs'
      end
      api.add_params(invalidate: invalidate)
      json = api.execute!

      json[:metrics].map do |plan|
        new(plan)
      end
    end

    #
    # Returns suggestions for a specified term
    #
    # @param [String] term A term to return suggestions for
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Subscription>]
    #
    def self.get_term!(term , access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = "/system/{{client_id}}/terms/#{term}/suggestions"
      end.execute!

      json[:suggestions].map do |element|
        new(element)
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
    alias_accessor :id,              :Id
    alias_accessor :name,            :Name
    alias_accessor :pricing_plan_id, :PricingPlanId
    alias_accessor :price,           :Price
    alias_accessor :currency_code,   :CurrencyCode

    # Compatibility with response JSON
    alias_method :ref_id=, :id=

    #
    # Dynamically generate accessors for existing subscription plan limits.
    #
    LIMITS.each do |snake, camel|
      # @attr [GroupDocs::Subscription::Limit] limit
      attr_accessor camel

      # Human-readable accessors
      alias_accessor snake, camel.to_sym

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
