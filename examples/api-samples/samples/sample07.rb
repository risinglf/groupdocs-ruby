# GET request
get '/sample07' do
  haml :sample07
end

# POST request
post '/sample07' do
  # Set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :base_path, params[:base_path]

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

    # Make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {:extended => true}, {:client_id => settings.client_id, :private_key => settings.private_key})

    # Construct result string
    thumbnails = ''
    files_list.each do |element|
      if element.class.name.split('::').last == 'Folder'
        next
      end
      if element.thumbnail
        name = element.name
        thumbnails += "<p><img src='data:image/png;base64,#{element.thumbnail}', width='40px', height='40px'> #{name}</p>"
      end
    end

    unless thumbnails.empty?
      set :thumbnails, thumbnails
    end

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample07, :locals => {:client_id => settings.client_id, :private_key => settings.private_key, :thumbnailList => thumbnails, :err => err}
end
