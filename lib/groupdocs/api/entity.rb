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
            send(:"#{attr}=", value)
          end
        end
      end

    end # Entity
  end # Api
end # GroupDocs
