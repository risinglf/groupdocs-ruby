require 'rest-client'
require 'json'
require 'groupdocs/api/helpers'
require 'groupdocs/api/entity'

module GroupDocs
  module Api
    class Request

      include GroupDocs::Api::Helpers::URL

      DEFAULT_HEADERS = { accept: 'application/json' }

      attr_reader   :resource
      attr_reader   :response
      attr_accessor :options

      def initialize(options = {}, &blk)
        @options = options
        blk.call(@options) if block_given?
        @resource = RestClient::Resource.new(GroupDocs.api_server)
        prepend_version
      end

      def execute!
        sign_url
        send_request
        parse_response
      end

      private

      def send_request
        if options[:headers].is_a?(Hash)
          options[:headers].merge!(DEFAULT_HEADERS)
        else
          options[:headers] = DEFAULT_HEADERS
        end
        options[:method] = options[:method].downcase
        if options[:request_body]
          options[:request_body] = options[:request_body].to_json
        end

        @response = case options[:method]
          when :get
           resource[options[:path]].get(options[:headers])
          when :post
            resource[options[:path]].post(options[:request_body], options[:headers])
          when :put
            resource[options[:path]].put(options[:request_body], options[:headers])
          when :delete
            resource[options[:path]].delete(options[:headers])
          else
            raise GroupDocs::Errors::UnsupportedMethodError, "Unsupported HTTP method: #{options[:method].inspect}"
        end
      end

      def parse_response
        # HACK we get char in the beginning of JSON which leads to syntax error
        unless response.chars.first == '{'
          response.sub!(/^.{1}/, '')
        end
        json = JSON.parse(response, symbolize_names: true)

        if json[:status] != 'Ok'
          raise GroupDocs::Errors::IncorrectResponseStatus, "Received bad response - #{json.inspect}"
        end

        json
      end

    end # Request
  end # Api
end # GroupDocs
