module GroupDocs
  class Post < Api::Entity


    # Rename by post.
    #
    # @param [Hash] options
    # @option file_id [String] :file_id
    # @option new_name [String] :new_name
    # @option user_id [String]:user_id
    # @return [Array]
    #
    def self.rename!(options = {})
      api = Api::Request.new do |request|
        request[:method] = :POST
        request[:path] = '/post/file.rename'
      end
      api.add_params(options)
      json = api.execute!

      new(json)
    end

    # Delete by post.
    #
    # @param [Hash] options
    # @option file_id [String] :file_id
    # @option user_id [String]:user_id
    # @return [Array]
    #
    def self.delete!(options = {})
      api = Api::Request.new do |request|
        request[:method] = :POST
        request[:path] = '/post/file.delete'
      end
      api.add_params(options)
      json = api.execute!

      new(json)
    end

    #  Delete from folder by post.
    #
    # @param [Hash] options
    # @option user_id [String] :user_id
    # @option path [String] :path
    # @return [Array]
    #
    def self.delete_from_folder!(options = {})
      api = Api::Request.new do |request|
        request[:method] = :POST
        request[:path] = '/post/file.delete.in'
      end
      api.add_params(options)
      json = api.execute!

      new(json)
    end

    #  Compress by post.
    #
    # @param [Hash] options
    # @option user_id [String] :user_id
    # @option file_id [String] :file_id
    # @option archive [String] :archive_type
    # @return [Array]
    #
    def self.compress!(options = {})
      api = Api::Request.new do |request|
        request[:method] = :POST
        request[:path] = '/post/file.compress'
      end
      api.add_params(options)
      json = api.execute!

      new(json)
    end




  end # Post
end # GroupDocs