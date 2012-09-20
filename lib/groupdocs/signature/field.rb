module GroupDocs
  class Signature::Field < Api::Entity

    require 'groupdocs/signature/field/location'

    #
    # Returns array of predefined lists.
    #
    # @param [Hash] options Hash of options
    # @option options [String] :id Filter by identifier
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    # @return [Array<GroupDocs::Signature::Field>]
    #
    def self.get!(options = {}, access = {})
      api = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :GET
        request[:path] = '/signature/{{client_id}}/fields'
      end
      api.add_params(options)
      json = api.execute!

      json[:fields].map do |field|
        new(field)
      end
    end

    # @attr [String] id
    attr_accessor :id
    # @attr [String] templateId
    attr_accessor :templateId
    # @attr [String] recipientId
    attr_accessor :recipientId
    # @attr [String] signatureFieldId
    attr_accessor :signatureFieldId
    # @attr [String] name
    attr_accessor :name
    # @attr [Integer] graphSizeW
    attr_accessor :graphSizeW
    # @attr [Integer] graphSizeH
    attr_accessor :graphSizeH
    # @attr [String] getDataFrom
    attr_accessor :getDataFrom
    # @attr [String] regularExpression
    attr_accessor :regularExpression
    # @attr [String] fontName
    attr_accessor :fontName
    # @attr [String] fontColor
    attr_accessor :fontColor
    # @attr [Integer] fontSize
    attr_accessor :fontSize
    # @attr [Boolean] fontBold
    attr_accessor :fontBold
    # @attr [Boolean] fontItalic
    attr_accessor :fontItalic
    # @attr [Boolean] fontUnderline
    attr_accessor :fontUnderline
    # @attr [Boolean] isSystem
    attr_accessor :isSystem
    # @attr [Integer] fieldType
    attr_accessor :fieldType
    # @attr [Boolean] acceptableValues
    attr_accessor :acceptableValues
    # @attr [String] defaultValue
    attr_accessor :defaultValue
    # @attr [String] tooltip
    attr_accessor :tooltip
    # @attr [Integer] input
    attr_accessor :input
    # @attr [Integer] order
    attr_accessor :order
    # @attr [String] textRows
    attr_accessor :textRows
    # @attr [String] textColumns
    attr_accessor :textColumns
    # @attr [GroupDocs::Signature::Field::Location] location
    attr_accessor :location
    # @attr [Array<GroupDocs::Signature::Field::Location>] locations
    attr_accessor :locations

    # Human-readable accessors
    alias_method :template_id,         :templateId
    alias_method :template_id=,        :templateId=
    alias_method :recipient_id,        :recipientId
    alias_method :recipient_id=,       :recipientId=
    alias_method :signature_field_id,  :signatureFieldId
    alias_method :signature_field_id=, :signatureFieldId=
    alias_method :graph_size_w,        :graphSizeW
    alias_method :graph_size_w=,       :graphSizeW=
    alias_method :graph_size_w,        :graphSizeW
    alias_method :graph_size_w=,       :graphSizeW=
    alias_method :graph_size_width,    :graphSizeW
    alias_method :graph_size_width=,   :graphSizeW=
    alias_method :graph_size_h,        :graphSizeH
    alias_method :graph_size_h=,       :graphSizeH=
    alias_method :graph_size_height,   :graphSizeH
    alias_method :graph_size_height=,  :graphSizeH=
    alias_method :get_data_from,       :getDataFrom
    alias_method :get_data_from=,      :getDataFrom=
    alias_method :regular_expression,  :regularExpression
    alias_method :regular_expression=, :regularExpression=
    alias_method :font_name,           :fontName
    alias_method :font_name=,          :fontName=
    alias_method :font_color,          :fontColor
    alias_method :font_color=,         :fontColor=
    alias_method :font_size,           :fontSize
    alias_method :font_size=,          :fontSize=
    alias_method :font_bold,           :fontBold
    alias_method :font_bold=,          :fontBold=
    alias_method :font_italic,         :fontItalic
    alias_method :font_italic=,        :fontItalic=
    alias_method :font_underline,      :fontUnderline
    alias_method :font_underline=,     :fontUnderline=
    alias_method :is_system,           :isSystem
    alias_method :is_system=,          :isSystem=
    alias_method :field_type,          :fieldType
    alias_method :field_type=,         :fieldType=
    alias_method :acceptable_values,   :acceptableValues
    alias_method :acceptable_values=,  :acceptableValues=
    alias_method :default_value,       :defaultValue
    alias_method :default_value=,      :defaultValue=
    alias_method :text_rows,           :textRows
    alias_method :text_rows=,          :textRows=
    alias_method :text_columns,        :textColumns
    alias_method :text_columns=,       :textColumns=

    #
    # Converts location to GroupDocs::Signature::Field::Location object.
    #
    # @param [GroupDocs::Signature::Field::Location, Hash] location
    #
    def location=(location)
      if location
        @location = (location.is_a?(GroupDocs::Signature::Field::Location) ? location : Signature::Field::Location.new(location))
        locations ? locations << @location : self.locations = [@location]
      end
    end

    #
    # Converts each location to GroupDocs::Signature::Field::Location object.
    #
    # @param [Array<GroupDocs::Signature::Field::Location, Hash>] locations
    #
    def locations=(locations)
      if locations
        @locations = locations.map do |location|
          if location.is_a?(GroupDocs::Signature::Field::Location)
            location
          else
            Signature::Field::Location.new(location)
          end
        end
      end
    end

    #
    # Creates signature field.
    #
    # @example
    #   field = GroupDocs::Signature::Field.new
    #   field.name = 'Field'
    #   field.create!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def create!(access = {})
      json = Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = '/signature/{{client_id}}/field'
        request[:request_body] = to_hash
      end.execute!

      self.id = json[:field][:id]
    end

    #
    # Modifies signature field.
    #
    # @example
    #   field = GroupDocs::Signature::Field.get!.first
    #   field.name = 'Field'
    #   field.modify!
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def modify!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :POST
        request[:path] = "/signature/{{client_id}}/fields/#{id}"
        request[:request_body] = to_hash
      end.execute!
    end

    #
    # Deletes signature field.
    #
    # @example Remove all created fields
    #   fields = GroupDocs::Signature::Field.get!.select { |field| !field.is_system }
    #   fields.each { |field| field.delete! }
    #
    # @param [Hash] access Access credentials
    # @option access [String] :client_id
    # @option access [String] :private_key
    #
    def delete!(access = {})
      Api::Request.new do |request|
        request[:access] = access
        request[:method] = :DELETE
        request[:path] = "/signature/{{client_id}}/fields/#{id}"
      end.execute!
    end

  end # Signature::Field
end # GroupDocs
