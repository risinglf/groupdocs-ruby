# GET request
get '/sample17' do
  haml :sample17
end

# POST request
post '/sample17' do
  # set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :file, params[:file]
  set :base_path, params[:basePath]

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.file.nil?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # construct path
    filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
    # open file
    File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
    # upload file
    file = GroupDocs::Storage::File.upload!(filepath, {})
    # compress file
    file.compress!()

    # construct result messages
    massage = "<p>Archive created and saved successfully. Here you can see your <strong>#{params[:file][:filename]}</strong> file in the GroupDocs Embedded Viewer.</p>"

    #Get url from request
    case settings.base_path

      when 'https://stage-api-groupdocs.dynabic.com'
        url = "http://stage-apps-groupdocs.dynabic.com/document-viewer/embed/#{file.guid}"
      when 'https://dev-api-groupdocs.dynabic.com'
        url = "http://dev-apps-groupdocs.dynabic.com/document-viewer/embed/#{file.guid}"
      else
        url = "https://apps.groupdocs.com/document-viewer/embed/#{file.guid}"
    end

    # Add the signature to the url request
    iframe = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url
    # Construct result iframe
    iframe = "<iframe src='#{iframe}' frameborder='0' width='100%' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample17, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :iframe => iframe, :massage => massage, :err => err}
end
