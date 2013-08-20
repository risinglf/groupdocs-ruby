# GET request
get '/sample30' do
  haml :sample30
end

# POST request
post '/sample30' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:fileId]

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty?

    # make a request to API using client_id and private_key
    file = GroupDocs::Storage::File.new({:guid => settings.file_id})

    # delete file from GroupDocs Storage
    result = file.delete!({:client_id => settings.client_id, :private_key => settings.private_key})

    message = 'File was deleted from GroupDocs Storage'

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample30, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :message => message, :fileId => settings.file_id, :err => err}
end
