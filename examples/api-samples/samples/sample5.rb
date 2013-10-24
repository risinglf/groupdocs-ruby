# GET request
get '/sample5' do
  haml :sample5
end

# POST request
post '/sample5' do
  # Set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:fileId]
  set :url, params[:url]
  set :copy, params[:copy]
  set :move, params[:move]
  set :dest_path, params[:dest_path]
  set :source, params[:source]

  begin

    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
    end

    file = nil
    # Get document by file GUID
    case settings.source
      when 'guid'
        file = GroupDocs::Storage::File.new({:guid => settings.file_id}).to_document
        # Obtaining all Metadata for file
        document = file.metadata!
        file = document.last_view.document.file
      when 'local'
        # Construct path
        filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
        # Open file
        File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
        # Make a request to API using client_id and private_key
        file = GroupDocs::Storage::File.upload!(filepath, {})
      when 'url'
        file = GroupDocs::Storage::File.upload_web!(settings.url)
      else
        raise 'Wrong GUID source.'
    end

    # Copy file using request to API
    unless settings.copy.nil?
      file = file.copy!(settings.dest_path, {})
      button = settings.copy
    end

    # Move file using request to API
    unless settings.move.nil?
      file = file.move!(settings.dest_path, {})
      button = settings.move
    end

    # Result message
    if file
      massage = "File was #{button}'ed to the #{settings.dest_path} folder"
    end

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample5, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :file_id => settings.file_id, :dest_path => settings.dest_path, :massage => massage, :err => err}
end
