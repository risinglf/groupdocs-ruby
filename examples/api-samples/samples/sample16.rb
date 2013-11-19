# GET request
get '/sample16' do
  haml :sample16
end

# POST request
post '/sample16' do
  # Set variables
  set :fileId, params[:fileId]
  set :base_path, params[:base_path]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.fileId.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

     #Get url from request
    case settings.base_path

      when 'https://stage-api-groupdocs.dynabic.com'
        url = "http://stage-apps-groupdocs.dynabic.com/assembly2/questionnaire-assembly/#{settings.fileId}"
      when 'https://dev-api-groupdocs.dynabic.com'
        url = "http://dev-apps-groupdocs.dynabic.com/assembly2/questionnaire-assembly/#{settings.fileId}"
      else
        url = "https://apps.groupdocs.com/assembly2/questionnaire-assembly/#{settings.fileId}"
    end

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