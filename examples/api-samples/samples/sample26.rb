# GET request
get '/sample26' do
  haml :sample26
end

# POST request
post '/sample26' do
  set :email, params[:email]
  set :password, params[:password]
  set :base_path, params[:basePath]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.email.empty? or settings.password.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end
    # Make a request to API using email and password
    user = GroupDocs::User.login!(settings.email, settings.password)

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample26, :locals => {:user => user, :err => err}
end
