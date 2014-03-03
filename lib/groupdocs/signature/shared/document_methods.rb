module GroupDocs
  class Signature
    #
    # Envelope and template entities share the same set of document methods.
    #
    # @see GroupDocs::Signature::Envelope
    # @see GroupDocs::Signature::Form
    # @see GroupDocs::Signature::Template
    #
    module DocumentMethods

      #
      # Returns documents array.
      #
      # @param [Hash] options
      # @option options [Boolean] :public Defaults to false
      # @option options [GroupDocs::Signature::Recipient] :recipient Used if :public is true and self is envelope
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @return [Array<GroupDocs::Document>]
      #
      def documents!(options = {}, access = {})
        path = if options[:public]
                 case class_name
                 when 'envelope'
                   options[:recipient].is_a?(GroupDocs::Signature::Recipient) or raise ArgumentError,
                     "Recipient should be GroupDocs::Signature::Recipient object, received: #{options[:recipient].inspect}"

                   "/signature/public/envelopes/#{id}/recipient/#{options[:recipient].id}/documents"
                 when 'form'
                   "/signature/public/forms/#{id}/documents"
                 else
                   raise ArgumentError, "Public is supported only for envelope or form."
                 end
               else
                 "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/documents"
               end

        json = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :GET
          request[:path] = path
        end.execute!

        json[:documents].map do |document|
          id = document[:documentId] || document[:id]
          file = Storage::File.new(:guid => id, :name => document[:name])
          Document.new(document.merge(:file => file))
        end

      end

      #
      # Adds document.
      #
      # @example
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   document = GroupDocs::Storage::Folder.list!.last.to_document
      #   template.add_document! document
      #
      # @example
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   document = GroupDocs::Storage::Folder.list!.last.to_document
      #   envelope.add_document! document
      #
      # @param [GroupDocs::Document] document
      # @param [Hash] options
      # @option options [Boolean] :parseFields Try to parse fields in document
      # @option options [Integer] :order Display order of the document
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if document is not GroupDocs::Document
      #
      def add_document!(document, options = {}, access = {})
        document.is_a?(GroupDocs::Document) or raise ArgumentError,
          "Document should be GroupDocs::Document object, received: #{document.inspect}"

        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :POST
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/document/#{document.file.guid}"
        end
        api.add_params(options)
        api.execute!
      end

      #
      # Removes document.
      #
      # @example
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   document = template.documents!.first
      #   template.remove_document! document
      #
      # @example
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   document = envelope.documents!.first
      #   envelope.remove_document! document
      #
      # @param [GroupDocs::Document] document
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if document is not GroupDocs::Document
      #
      def remove_document!(document, access = {})
        document.is_a?(GroupDocs::Document) or raise ArgumentError,
          "Document should be GroupDocs::Document object, received: #{document.inspect}"

        Api::Request.new do |request|
          request[:access] = access
          request[:method] = :DELETE
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/documents/#{document.file.guid}"
        end.execute!
      end

      #
      #  Rename signature template document
      #
      # @example Rename document from template
      #   template = GroupDocs::Signature::Template.get!("g94h5g84hj9g4gf23i40j")
      #   document = template.documents!.first
      #   template.rename_document! (new_name, document)
      #
      # @example Rename document from envelope
      #   envelope = GroupDocs::Signature::Envelope.get!("g94h5g84hj9g4gf23i40j")
      #   document = envelope.documents!.first
      #   envelope.rename_document! (new_name, document)
      #
      # @example Rename document from form
      #   form = GroupDocs::Signature::Form.get!("g94h5g84hj9g4gf23i40j")
      #   document = envelope.documents!.first
      #   form.rename_document! (new_name, document)
      #
      # @param [GroupDocs::Signature::Field] field
      # @param [Hash] access Access credentials
      # @option access [String] :client_id
      # @option access [String] :private_key
      # @raise [ArgumentError] if field is not GroupDocs::Signature::Field
      #
      def rename_document!(new_name, document, access = {})
        document.is_a?(GroupDocs::Document) or raise ArgumentError,
                                                          "Document should be GroupDocs::Document object, received: #{document.inspect}"

        api = Api::Request.new do |request|
          request[:access] = access
          request[:method] = :PUT
          request[:path] = "/signature/{{client_id}}/#{class_name.pluralize}/#{id}/document/#{document.file.guid}"
        end
        api.add_params(:newName => new_name)
        api.execute!
      end

    end # DocumentMethods
  end # Signature
end # GroupDocs
