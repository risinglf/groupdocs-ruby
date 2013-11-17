# GET request
get '/sample04' do
  haml :sample04
end

# POST request
post '/sample04' do
  # Set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:file_id]
  set :url, params[:url]
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

    # Get file GUID
    file = GroupDocs::Storage::File.new({:guid => settings.file_id}).to_document

    # Obtaining all Metadata for file
    document = file.metadata!
    file = document.last_view.document.file
    # Download file
    dowloaded_file = file.download!("#{File.dirname(__FILE__)}/../public/downloads")
    unless dowloaded_file.empty?
      massage = "<font color='green'>File was downloaded to the <font color='blue'>#{dowloaded_file}</font> folder</font> <br />"
    end

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample04, :locals => {:client_id => settings.client_id, :private_key => settings.private_key, :file_id => settings.file_id, :massage => massage, :err => err}
end
