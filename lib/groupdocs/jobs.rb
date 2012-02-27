require 'groupdocs/jobs/job'

module GroupDocs
  #
  # Implementation of general jobs API.
  #
  # @example
  #   GroupDocs::Jobs.get
  #     #=> []
  #   GroupDocs::Job.create!
  #     #=> Job
  #
  # @see http://scotland.groupdocs.com/wiki/display/api/General+API
  #
  module Jobs
    class << self

      include GroupDocs::Api

      #
      # Returns an array of recent jobs.
      #
      # @param [Hash] options
      # @options [Integer] :page
      # @options [Integer] :count
      #
      # @return [Array]
      #
      def get!(options = {})
        api = GroupDocs::Api::Request.new do |request|
          request[:method] = :GET
          request[:path] = "/#{GroupDocs.client_id}/jobs"
        end
        api.add_params(options)
        api.execute
      end

    end # << self
  end # Jobs
end # GroupDocs
