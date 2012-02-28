# encoding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'simplecov'
SimpleCov.configure do
  add_filter('spec/')
  add_filter('vendor/')
end
SimpleCov.start

require 'groupdocs'

#
# Mocks GroupDocs::Api::Request.
#
def mock_api_request(path)
  subject.should_receive(:options).any_number_of_times.and_return({})
  subject.options.should_receive(:[]).with(:path).any_number_of_times.and_return(path.dup)
end

#
# Mocks ResClient::Resource.
#
def mock_resource(method)
  subject.resource.should_receive(:[]).with(subject.options[:path]).any_number_of_times.and_return(subject.resource)
  subject.resource[subject.options[:path]].should_receive(method.downcase).with(any_args).and_return(true)
end
