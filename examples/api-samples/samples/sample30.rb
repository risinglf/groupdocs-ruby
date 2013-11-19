# GET request
get '/sample30' do
  haml :sample30
end

# POST request
post '/sample30' do
  # Set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :name, params[:name]
  set :base_path, params[:base_path]

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.name.empty?

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
      if element.respond_to?('name') == true and element.name == settings.name
        document = element
      end
    end


    # Delete file from GroupDocs Storage
    document.delete!()

    message = 'File was deleted from GroupDocs Storage'

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample30, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :message => message, :name => settings.name, :err => err}
end
