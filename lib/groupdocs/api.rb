require 'rest-client'
require 'json'
require 'groupdocs/api/helpers'

module GroupDocs
  module Api
    class Request

      include GroupDocs::Api::Helpers::URL

      DEFAULT_HEADERS = { accept: 'application/json' }

      attr_reader   :resource
      attr_accessor :options

      def initialize(options = {}, &blk)
        @options = options
        blk.call(@options) if block_given?
        @resource = RestClient::Resource.new(GroupDocs.api_server)
        prepend_version
      end

      def execute
        sign_url
        send_request(@options[:method], @options[:path], @options[:request_body], @options[:headers])
      end

      private

      def send_request(method, path, request_body, headers)
        headers ||= DEFAULT_HEADERS
        method = method.downcase

        case method
        when :post, :put
          headers = headers.merge(content_type: 'application/json')
          @resource[path].send(method, request_body.to_json, headers)
        else
          @resource[path].send(method, headers)
        end
      end

    end # Request
  end # Api
end # GroupDocs
