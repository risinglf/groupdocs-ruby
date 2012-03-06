module GroupDocs
  module Api
    module Helpers
      module REST

        DEFAULT_HEADERS = { accept: 'application/json',
                            content_length: 0 }

        private

        def prepare_request
          # prepare headers
          if options[:headers].is_a?(Hash)
            options[:headers].merge!(DEFAULT_HEADERS)
          else
            options[:headers] = DEFAULT_HEADERS
          end
          # prepare method
          options[:method] = options[:method].downcase
          # prepare response body
          if options[:request_body] and not options[:request_body][:upload]
            options[:request_body] = options[:request_body].to_json
          end
        end

        def send_request
          self.response = case options[:method]
            when :get, :download
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
          # for DOWNLOAD requests, just return response
          if options[:method] == :download
            response
          # for all other requests, parse JSON
          else
            json = JSON.parse(response, symbolize_names: true)
            json[:status] == 'Ok' ? json : raise_bad_request_error(json)
          end
        end

        def raise_bad_request_error(json)
          raise GroupDocs::Errors::BadResponseError, <<-ERR
            Bad response!
            Request method: #{options[:method].upcase}
            Request URL: #{resource[options[:path]]}
            Request body: #{options[:request_body]}
            Status: #{json[:status]}
            Error message: #{json[:error_message]}
            Response body: #{response}
          ERR
        end

      end # Request
    end # Helpers
  end # Api
end # GroupDocs
