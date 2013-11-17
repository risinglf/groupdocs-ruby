# GET request
get '/sample12' do
  haml :sample12
end

# POST request
post '/sample12' do
  # Set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:fileId]
  set :base_path, params[:base_path]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty?

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
      # Get list of annotations
      annotations = document.to_document.annotations!()
    end

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample12, :locals => {:client_id => settings.client_id, :private_key => settings.private_key, :annotations => annotations, :fileId => settings.file_id, :err => err}
end
