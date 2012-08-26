module GroupDocs
  class Subscription::Limit < GroupDocs::Api::Entity

    # @attr [Integer] Id
    attr_accessor :Id
    # @attr [Integer] Min
    attr_accessor :Min
    # @attr [Integer] Max
    attr_accessor :Max
    # @attr [String] Description
    attr_accessor :Description

    # Human-readable accessors
    alias_method :id,           :Id
    alias_method :id=,          :Id=
    alias_method :min,          :Min
    alias_method :min=,         :Min=
    alias_method :max,          :Max
    alias_method :max=,         :Max=
    alias_method :description,  :Description
    alias_method :description=, :Description=

  end # Subscription::Limit
end # GroupDocs
