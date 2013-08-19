# GET request
get '/sample23' do
  haml :sample23
end

# POST request
post '/sample23' do
  # set variables

  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :source, params[:source]
  set :file_id, params[:fileId]
  set :url, params[:url]

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # get document by file GUID
    case settings.source
      when 'guid'
        # Create instance of File
        file = GroupDocs::Storage::File.new({:guid => settings.file_id})
      when 'local'
        # Construct path
        file_path = "#{Dir.tmpdir}/#{params[:file][:filename]}"
        # Open file
        File.open(file_path, 'wb') { |f| f.write(params[:file][:tempfile].read) }
        # Make a request to API using client_id and private_key
        file = GroupDocs::Storage::File.upload!(file_path, {}, {:client_id => settings.client_id, :private_key => settings.private_key})
      when 'url'
        # Upload file from defined url
        file = GroupDocs::Storage::File.upload_web!(settings.url, {:client_id => settings.client_id, :private_key => settings.private_key})
      else
        raise 'Wrong GUID source.'
    end

    # Raise exception if something went wrong
    raise 'No such file' unless file.is_a?(GroupDocs::Storage::File)

    # Make GroupDocs::Storage::Document instance
    document = file.to_document

    #Create new page
    page_image = document.page_images!(700, 700, {first_page: 0, page_count: 2}, {:client_id => settings.client_id, :private_key => settings.private_key})


    rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample23,  :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :page_image => page_image, :err => err}
end
