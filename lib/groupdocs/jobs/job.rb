module GroupDocs
  module Jobs
    #
    # GroupDocs job object.
    #
    class Job

      include GroupDocs::Api

      attr_reader :id
      attr_accessor :status
      attr_accessor :documents

      def initialize(options = {}, &blk)
        @id = options[:id]
        @status = options[:status]
        @documents = options[:documents]
        blk.call(self) if block_given?
      end

      def save!(options = {})
        api = GroupDocs::Api::Request.new do |request|
          request[:method] = :POST
          request[:path] = "/#{GroupDocs.client_id}/jobs"
          request[:request_body] = options
        end
        api.execute
      end

    end # Job
  end # Jobs
end # GroupDocs
