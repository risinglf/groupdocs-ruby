# GET request
get '/sample5' do
  haml :sample5
end

# POST request
post '/sample5' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:fileId]
  set :url, params[:url]
  set :copy, params[:copy]
  set :move, params[:move]
  set :dest_path, params[:dest_path]
  set :source, params[:source]

  begin

    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
    end

    file = nil
    # get document by file GUID
    case settings.source
      when 'guid'
        file = GroupDocs::Storage::File.new({:guid => settings.file_id}).to_document.metadata!()
        file = file.last_view.document.file
      when 'local'
        # construct path
        filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
        # open file
        File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
        # make a request to API using client_id and private_key
        file = GroupDocs::Storage::File.upload!(filepath, {})
      when 'url'
        file = GroupDocs::Storage::File.upload_web!(settings.url)
      else
        raise 'Wrong GUID source.'
    end
     # raise files_list.to_yaml
    # copy file using request to API
    unless settings.copy.nil?
      file = file.copy!(settings.dest_path, {})
      button = settings.copy
    end

    # move file using request to API
    unless settings.move.nil?
      file = file.move!(settings.dest_path, {})
      button = settings.move
    end

    # result message
    if file
      massage = "File was #{button}'ed to the #{settings.dest_path} folder"
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample5, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :file_id => settings.file_id, :dest_path => settings.dest_path, :massage => massage, :err => err}
end
