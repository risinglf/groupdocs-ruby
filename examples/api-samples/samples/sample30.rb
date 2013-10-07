# GET request
get '/sample30' do
  haml :sample30
end

# POST request
post '/sample30' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :name, params[:name]

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.name.empty?

    # get List files from GroupDocs Storage
    file = GroupDocs::Storage::Folder.list!("", {}, {:client_id => settings.client_id, :private_key => settings.private_key})
    file_name = ''

    # choose the desired file
    file.map do |element|
      if element.name == settings.name
          file_name = element
      end
    end

    # delete file from GroupDocs Storage
    file_name.delete!({:client_id => settings.client_id, :private_key => settings.private_key})

    message = 'File was deleted from GroupDocs Storage'

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample30, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :message => message, :name => settings.name, :err => err}
end
