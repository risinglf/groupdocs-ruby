# GET request
get '/sample13' do
  haml :sample13
end

# POST request
post '/sample13' do
  # Set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :file_id, params[:fileId]
  set :email, params[:email]
  set :base_path, params[:basePath]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty? or settings.email.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # Make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {})
    document = ''

    # Get document by file ID
    files_list.each do |element|
      if element.respond_to?('guid') == true and element.guid == settings.file_id
        document = element
      end
    end

    unless document.instance_of? String
      # Add collaborator to doc with annotations
      result = document.to_document.set_collaborators!(settings.email.split(' '), 1)
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample13, :locals => {:clientId => settings.client_id, :privateKey => settings.private_key, :fileId => settings.file_id, :email => settings.email, :result => result, :err => err}
end