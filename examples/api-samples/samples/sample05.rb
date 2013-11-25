# GET request
get '/sample05' do
  haml :sample05
end

# POST request
post '/sample05' do
  # set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :file_id, params[:srcPath]
  set :url, params[:url]
  set :copy, params[:copy]
  set :move, params[:move]
  set :dest_path, params[:destPath]
  set :source, params[:source]
  set :base_path, params[:basePath]

  begin

    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
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
      massage = "File was #{button}'ed to the <font color=\"blue\">#{settings.dest_path}</font> folder"
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample05, :locals => {:clientId => settings.client_id, :privateKey => settings.private_key, :fileId => settings.file_id, :destPath => settings.dest_path, :massage => massage, :err => err}
end
