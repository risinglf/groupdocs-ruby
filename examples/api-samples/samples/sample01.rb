# GET request
get '/sample01' do
  haml :sample01
end

# POST request
post '/sample01' do
  # Set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :base_path, params[:basePath]

  begin

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # make a request to API using client_id and private_key
    user = GroupDocs::User.get!()

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample01, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :user => user, :err => err}
end
