# GET request
get '/sample18' do
  haml :sample18
end

# POST request
post '/sample18/convert_callback' do
  # Set download path
  downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"

  # Get callback request
  data = JSON.parse(request.body.read)
  begin
    raise 'Empty params!' if data.empty?
    source_id = nil
    client_key = nil
    private_key = nil

    # Get value of SourceId
    data.each do |key, value|
      if key == 'SourceId'
        source_id = value
      end
    end

    # Get private key and client_key from file user_info.txt
    if File.exist?("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = File.read("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = contents.split(' ')
      client_key = contents.first
      private_key = contents.last
    end

    # Create Job instance
    job = GroupDocs::Job.new({:id => source_id})

    # Get document by job id
    documents = job.documents!({:client_id => client_key, :private_key => private_key})

    # Download converted file
    documents[:inputs].first.outputs.first.download!(downloads_path, {:client_id => client_key, :private_key => private_key})

  rescue Exception => e
    err = e.message
  end
end


# GET request
get '/sample18/check' do

  # Check is there download directory
  unless File.directory?("#{File.dirname(__FILE__)}/../public/downloads")
    return 'Directory was not found.'
  end

  # Get file name from download directory
  name = nil
  Dir.entries("#{File.dirname(__FILE__)}/../public/downloads").each do |file|
    name = file if file != '.' && file != '..'
  end

  name
end

# GET request
get '/sample18/downloads/:filename' do |filename|
  # Send file with header to download it
  send_file "#{File.dirname(__FILE__)}/../public/downloads/#{filename}", :filename => filename, :type => 'Application/octet-stream'
end


# POST request
post '/sample18' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :source, params[:source]
  set :file_id, params[:fileId]
  set :url, params[:url]
  set :convert_type, params[:convert_type]
  set :callback, params[:callback]

  # Set download path
  downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"

  # Remove all files from download directory or create folder if it not there
  if File.directory?(downloads_path)
    Dir.foreach(downloads_path) { |f| fn = File.join(downloads_path, f); File.delete(fn) if f != '.' && f != '..' }
  else
    Dir::mkdir(downloads_path)
  end

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # Write client and private key to the file for callback job
    if settings.callback[0]
      out_file = File.new("#{File.dirname(__FILE__)}/../public/user_info.txt", 'w')
      out_file.write("#{settings.client_id}")
      out_file.write("#{settings.private_key}")
      out_file.close
    end

    file = nil

    # get document by file GUID
    case settings.source
      when 'guid'
        # Create instance of File
        file = GroupDocs::Storage::File.new({:guid => settings.file_id})
      when 'local'
        # construct path
        file_path = "#{Dir.tmpdir}/#{params[:file][:filename]}"
        # open file
        File.open(file_path, 'wb') { |f| f.write(params[:file][:tempfile].read) }
        # make a request to API using client_id and private_key
        file = GroupDocs::Storage::File.upload!(file_path, {}, {:client_id => settings.client_id, :private_key => settings.private_key})
      when 'url'
        # Upload file from defined url
        file = GroupDocs::Storage::File.upload_web!(settings.url, {:client_id => settings.client_id, :private_key => settings.private_key})
      else
        raise 'Wrong GUID source.'
    end

    # Raise exception if something went wrong
    raise 'No such file' unless file.is_a?(GroupDocs::Storage::File)

    # Make document from file
    document = file.to_document
    # convert document
    convert = document.convert!(settings.convert_type, {:callback => settings.callback}, {:client_id => settings.client_id, :private_key => settings.private_key})
    # waite 10 seconds for while file converting
    sleep(10)

    # Get array of changes in document from job
    original_document = convert.documents!({:client_id => settings.client_id, :private_key => settings.private_key})

    # Get converted document GUID
    guid = original_document[:inputs].first.outputs.first.guid

    # Set iframe with document GUID or raise an error
    if guid
      iframe = "<iframe width='100%' height='600' frameborder='0' src='https://apps.groupdocs.com/document-viewer/embed/#{guid}'></iframe>"
    else
      raise 'File was not converted'
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample18, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :callback => settings.callback, :fileId => file, :converted => guid, :iframe => iframe, :err => err}
end
