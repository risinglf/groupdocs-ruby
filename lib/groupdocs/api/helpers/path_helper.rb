module GroupDocs
  module Api
    module Helpers
      module Path

        #
        # Verifies path starts with root.
        #
        # @raise [ArgumentError] If path does not start with /
        # @api private
        #
        def self.verify_starts_with_root(path)
          path.chars.first == '/' or raise ArgumentError, "Path should start with /: #{path.inspect}"
        end

        #
        # Appends file name to path if it's not present.
        #
        # @api private
        #
        def self.append_file_name(path, name)
          path << "/#{Object::File.basename(name)}" unless /\.(\w){3,4}$/ === path
        end

      end # Path
    end # Helpers
  end # Api
end # GroupDocs
