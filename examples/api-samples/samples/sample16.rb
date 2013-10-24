# GET request
get '/sample16' do
  haml :sample16
end

# POST request
post '/sample16' do
  # Set variables
  set :fileId, params[:fileId]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.fileId.empty?

    url = "https://apps.groupdocs.com/assembly2/questionnaire-assembly/#{settings.fileId}"
    # Add the signature to the url request
    iframe = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url
    # Construct result iframe
    iframe = "<iframe src='#{iframe}' frameborder='0' width='100%' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample16, :locals => {:fileId => settings.fileId, :iframe => iframe, :err => err}
end