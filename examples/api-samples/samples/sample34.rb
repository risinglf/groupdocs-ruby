# GET request
get '/sample34' do
  haml :sample34
end

# POST request
post '/sample34' do
  # Set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :path, params[:folder]
  set :base_path, params[:basePath]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # Create new Folder
    folder = GroupDocs::Storage::Folder.create!(settings.path)
    if folder.id
       message = "<span style=\"color:green\">Folder was created #{folder.path} </span> "
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample34, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :message => message, :err => err}
end
