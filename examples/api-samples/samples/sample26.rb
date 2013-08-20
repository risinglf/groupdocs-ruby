# GET request
get '/sample26' do
  haml :sample26
end

# POST request
post '/sample26' do
  set :email, params[:email]
  set :password, params[:password]


  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.email.empty? or settings.password.empty?

    # make a request to API using email and password
    user = GroupDocs::User.login!(settings.email, settings.password)

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample26, :locals => {:user => user, :err => err}
end
