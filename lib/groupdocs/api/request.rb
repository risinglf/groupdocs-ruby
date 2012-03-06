require 'rest-client'
require 'json'
require 'groupdocs/api/helpers'

module GroupDocs
  module Api
    class Request

      include GroupDocs::Api::Helpers::URL
      include GroupDocs::Api::Helpers::REST

      attr_reader   :resource
      attr_accessor :response
      attr_accessor :options

      def initialize(options = {}, &blk)
        @options = options
        blk.call(@options) if block_given?
        @resource = RestClient::Resource.new(GroupDocs.api_server)
      end

      def execute!
        prepend_version
        sign_url
        prepare_request
        send_request
        parse_response
      end

    end # Request
  end # Api
end # GroupDocs
