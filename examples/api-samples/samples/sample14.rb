# GET request
get '/sample14' do
  haml :sample14
end

# POST request
post '/sample14' do
  # set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :folder, params[:path]
  set :base_path, params[:basePath]

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.folder.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end
    folder = nil
    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!()

    files_list.map do |e|
      if e.name == settings.folder
        folder = e
      end
    end


    # get list of shares for a folder
    shares = folder.sharers!()

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample14, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :folder => settings.folder, :shares => shares, :err => err}
end