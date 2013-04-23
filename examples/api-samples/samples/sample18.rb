# GET request
get '/sample18' do
  haml :sample18
end

# 
post '/sample18/convert_callback' do
  downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"

  data = JSON.parse(request.body.read)
  begin
    raise 'Empty params!' if data.empty?
    source_id = nil
    client_key = nil
    private_key = nil

    data.each do |key, value|
      if key == 'SourceId'
        source_id = value
      end
    end

    if File.exist?("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = File.read("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = contents.split(' ')
      client_key = contents.first
      private_key = contents.last
    end

    job = GroupDocs::Job.new({:id => source_id})

    documents = job.documents!({:client_id => client_key, :private_key => private_key})

    documents[:inputs].first.outputs.first.download!(downloads_path, {:client_id => client_key, :private_key => private_key})

  rescue Exception => e
    err = e.message
  end
end


# 
get '/sample18/check' do

  unless File.directory?("#{File.dirname(__FILE__)}/../public/downloads")
    return 'Directory was not found.'
  end

  name = nil
  Dir.entries("#{File.dirname(__FILE__)}/../public/downloads").each do |file|
    name = file if file != '.' && file != '..'
  end

  name
end

#
get '/sample18/downloads/:filename' do |filename|
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

  downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"
  if File.directory?(downloads_path)
    Dir.foreach(downloads_path) { |f| fn = File.join(downloads_path, f); File.delete(fn) if f != '.' && f != '..' }
  else
    Dir::mkdir(downloads_path)
  end

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

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
        file = GroupDocs::Storage::File.new({:guid => settings.file_id})
      when 'local'
        # construct path
        file_path = "#{Dir.tmpdir}/#{params[:file][:filename]}"
        # open file
        File.open(file_path, 'wb') { |f| f.write(params[:file][:tempfile].read) }
        # make a request to API using client_id and private_key
        file = GroupDocs::Storage::File.upload!(file_path, {}, client_id: settings.client_id, private_key: settings.private_key)
      when 'url'
        file = GroupDocs::Storage::File.upload_web!(settings.url, client_id: settings.client_id, private_key: settings.private_key)
      else
        raise 'Wrong GUID source.'
    end

    raise 'No such file' unless file.is_a?(GroupDocs::Storage::File)

    document = file.to_document
    # convert file
    convert = document.convert!(settings.convert_type, {:callback => settings.callback}, {:client_id => settings.client_id, :private_key => settings.private_key})
    sleep(10)

    original_document = convert.documents!({:client_id => settings.client_id, :private_key => settings.private_key})
    pp original_document

    guid = original_document[:inputs].first.outputs.first.guid

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
