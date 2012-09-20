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
          yield self if block_given?
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
        instance_variables.each do |variable|
          key = variable.to_s.delete(?@).to_sym
          value = instance_variable_get(variable)

          hash[key] = case value
                      when GroupDocs::Api::Entity
                        value.to_hash
                      when Array
                        value.map do |i|
                          i.respond_to?(:to_hash) ? i.to_hash : i
                        end
                      else
                        value
                      end
        end

        hash
      end

      #
      # Inspects object using accessors instead of instance variables values.
      #
      # @api private
      #
      def inspect
        not_nil_variables = instance_variables.select do |variable|
          !send(variable_to_accessor(variable)).nil?
        end

        variables = not_nil_variables.map  do |variable|
          accessor = variable_to_accessor(variable)
          value = send(accessor)
          value = case value
                  when Symbol then ":#{value}"
                  when String then "\"#{value}\""
                  else value
                  end
          "@#{accessor}=#{value}"
        end

        inspected = self.to_s
        unless variables.empty?
          inspected.gsub!(/>$/, '')
          inspected << " #{variables.join(', ')}"
          inspected << ?>
        end

        inspected
      end

      private

      #
      # Converts instance variable symbol to accessor method symbol.
      # @api private
      #
      def variable_to_accessor(variable)
        word = variable.to_s.delete(?@)
        word.gsub!(/(?<=[a-z])[A-Z]/) { |match| "_#{match}" }
        word.downcase!
        word.to_sym
      end

      #
      # Converts accessor symbol to instance variable symbol.
      # @api private
      #
      def accessor_to_variable(accessor)
        word = accessor.to_s
        word.capitalize!
        word.gsub!(/_([a-z])/) { |match| match.upcase }
        word.gsub!(/_/, '')
        "@#{word}".to_sym
      end

      #
      # Returns pluralized class name.
      # @api private
      #
      def pluralized_class
        "%ss" % self.class.name.split('::').last.downcase
      end

    end # Entity
  end # Api
end # GroupDocs
