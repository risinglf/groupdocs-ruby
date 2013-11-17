# GET request
get '/sample02' do
  haml :sample02
end

# POST request
post '/sample02' do
  # Set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :base_path, params[:base_path]

  begin

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # Make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {})

    # Construct list of files
    filelist = ''
    files_list.each { |element| filelist << "#{element.name}<br />" }

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample02, :locals => {:user_id => settings.client_id, :private_key => settings.private_key, :filelist => filelist, :err => err}
end
