module GroupDocs
  module Api
    class Entity

      #
      # Implements flexible API object creation.
      #
      # You can pass hash of options to automatically set attributes.
      #
      # @example Create folder with options hash
      #   GroupDocs::Storage::Folder.new(id: 1, name 'Test', url: 'http://groupdocs.com/folder/test')
      #   #=> <#GroupDocs::Storage::Folder @id=1 @name="Test" @url="http://groupdocs.com/folder/test">
      #
      # You can also pass block to set up attributes.
      #
      # @example Create folder with block
      #   GroupDocs::Storage::Folder.new do |folder|
      #     folder.id = 1
      #     folder.name = 'Test'
      #     folder.url = 'http://groupdocs.com/folder/test'
      #   end
      #   #=> <#GroupDocs::Storage::Folder @id=1 @name="Test" @url="http://groupdocs.com/folder/test">
      #
      # @param [Hash] options Each option is object attribute
      # @yield [self] Use block to set up attributes
      #
      def initialize(options = {}, &blk)
        if options.empty?
          blk.call(self) if block_given?
        else
          options.each do |attr, value|
            send(:"#{attr}=", value) if respond_to?(:"#{attr}=")
          end
        end
      end

      #
      # Recursively converts object and all its attributes to hash.
      #
      # @example Convert simple object to hash
      #   object = GroupDocs::Storage::File.new(id: 1, name, 'Test.pdf')
      #   object.to_hash
      #   #=> { id: 1, name: 'Test.pdf' }
      #
      # @return [Hash]
      #
      def to_hash
        hash = {}
        instance_variables.each do |var|
          key = var.to_s.delete(?@).to_sym
          value = instance_variable_get(var)
          hash[key] = case value
            when GroupDocs::Api::Entity
              value.to_hash
            when Array
              value.map do |i|
                i.to_hash if i.respond_to?(:to_hash)
              end
            else
              value
            end
        end

        hash
      end

    end # Entity
  end # Api
end # GroupDocs
