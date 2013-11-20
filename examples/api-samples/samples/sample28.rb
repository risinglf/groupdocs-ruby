# GET request
get '/sample28' do
  haml :sample28
end

# POST request
post '/sample28' do
  # set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :file_id, params[:fileId]
  set :base_path, params[:basePath]

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {})
    document = ''

    # get document by file ID
    files_list.each do |element|
      if element.respond_to?('guid') == true and element.guid == settings.file_id
        document = element
      end
    end


    unless document.instance_of? String
      # get list of annotations
      annotations = document.to_document.annotations!()

      # delete all annotations from document
      annotations.each do |annotation|
          annotation.remove!()
      end

      message = 'Annotations was deleted from document'
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample28, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :messages => message,  :fileId => settings.file_id, :err => err}
end
