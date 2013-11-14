# GET request
get '/sample4' do
  haml :sample4
end

# POST request
post '/sample4' do
  # Set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:file_id]
  set :url, params[:url]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
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
  haml :sample4, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :file_id => settings.file_id, :massage => massage, :err => err}
end
