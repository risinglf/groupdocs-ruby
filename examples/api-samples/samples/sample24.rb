# GET request
get '/sample24' do
  haml :sample24
end

# POST request
post '/sample24' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :url, params[:url]

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.url.nil?

    # upload web file
    file = GroupDocs::Storage::File.upload_web!(settings.url, {:client_id => settings.client_id, :private_key => settings.private_key})

    # construct result messages
    message = "<p>File was uploaded to GroupDocs. Here you can see your <strong> file in the GroupDocs Embedded Viewer.</p>"
    iframe = "<iframe src='https://apps.groupdocs.com/document-viewer/Embed/#{file.guid}' frameborder='0' width='720' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample24, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :iframe => iframe, :message => message, :err => err}
end
