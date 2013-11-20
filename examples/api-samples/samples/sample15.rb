# GET request
get '/sample15' do
  haml :sample15
end

# POST request
post '/sample15' do
  # Set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
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

    # Check the number of document's views. Make a request to API using client_id and private_key
    views = GroupDocs::Document.views!({})
    total = views.count()

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample15, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :total => total, :err => err}
end