# GET request
get '/sample22' do
  haml :sample22
end

# POST request
post '/sample22' do
  # Set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :fileId, params[:fileId]
  set :email, params[:email]
  set :first_name, params[:first_name]
  set :last_name, params[:last_name]

  begin

    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.fileId.empty? or settings.email.empty? or settings.first_name.empty? or settings.last_name.empty?

    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
    end

    # Create new user
    user = GroupDocs::User.new
    user.primary_email = settings.email
    user.nickname = settings.first_name
    user.first_name = settings.first_name
    user.last_name = settings.last_name

    # Update account
    new_user = GroupDocs::User.update_account!(user)

    # Create file from GUID
    file = GroupDocs::Storage::File.new(guid: settings.fileId)

    # Create document from file
    document = GroupDocs::Document.new(file: file)

    # Set new collaboration
    document.set_collaborators!([settings.email], 2)

    # Get all collaborations
    collaborations = document.collaborators!()

    # Set document reviewers
    document.set_reviewers!(collaborations)

    # Add the signature to url the request
    url = "https://apps.groupdocs.com//document-annotation2/embed/#{document.file.guid}?uid = #{new_user.guid}&download=true frameborder='0' width='720' height='600'"
    iframe = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url

    iframe = "<iframe src='#{iframe}' frameborder='0' width='720' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample22, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :fileId => settings.fileId, :email => settings.email, :first_name => settings.first_name, :last_name => settings.last_name, :iframe => iframe, :err => err}
end
