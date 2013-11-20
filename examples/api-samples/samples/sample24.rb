# GET request
get '/sample24' do
  haml :sample24
end

# POST request
post '/sample24' do
  # set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :url, params[:url]
  set :base_path, params[:basePath]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.url.nil?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # Upload web file
    file = GroupDocs::Storage::File.upload_web!(settings.url, {:client_id => settings.client_id, :private_key => settings.private_key})

    # Construct result messages
    message = "<p>File was uploaded to GroupDocs. Here you can see your <strong> file in the GroupDocs Embedded Viewer.</p>"

    #Get url from request
    case settings.base_path

      when 'https://stage-api-groupdocs.dynabic.com'
        url = "http://stage-apps-groupdocs.dynabic.com/document-viewer/embed/#{file.guid}"
      when 'https://dev-api-groupdocs.dynabic.com'
        url = "http://dev-apps-groupdocs.dynabic.com/document-viewer/embed/#{file.guid}"
      else
        url = "https://apps.groupdocs.com/document-viewer/embed/#{file.guid}"
    end

    # Add the signature to url te request
    iframe = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url

    # Construct result iframe
    iframe = "<iframe src='#{iframe}' frameborder='0' width='720' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample24, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :iframe => iframe, :message => message, :err => err}
end
