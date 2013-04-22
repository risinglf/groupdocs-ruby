# GET request
get '/sample18' do
  haml :sample18
end

# 
post '/sample18/convert_callback' do
  downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"

  unless File.directory?(downloads_path)
    Dir::mkdir(downloads_path)
  else
    Dir.foreach(downloads_path) {|f| fn = File.join(downloads_path, f); File.delete(fn) if f != '.' && f != '..'}
  end

  data = JSON.parse(request.body.read)
  begin
    raise "Empty params!" if data.empty?
    sourceId = nil
    client_key = nil
    private_key = nil

    data.each do |key, value|
      if key == 'SourceId'
        sourceId = value
      end
    end

    if File.exist?("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = File.read("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = contents.split(' ')
      client_key = contents.first
      private_key = contents.last
    end

    job = GroupDocs::Job.new({:id=>sourceId})

    documents = job.documents!({:client_id => client_key, :private_key => private_key})

    documents[:inputs].first.outputs.first.download!(downloads_path, {:client_id => client_key, :private_key => private_key})

  rescue Exception => e
    err = e.message
  end
end


# 
get '/sample18/check' do
  
  unless File.directory?("#{File.dirname(__FILE__)}/../public/downloads")
    return "Directory was not found."
  end

  name = nil
  Dir.entries("#{File.dirname(__FILE__)}/../public/downloads").each do |file|
    name = file if file != '.' && file != '..'
  end

  if name
    return "<a href='/downloads/#{name}'>#{name}</a>"
  else
    return "File was not found."
  end
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

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?
   
    if settings.callback[0]
      outFile = File.new("#{File.dirname(__FILE__)}/../public/user_info.txt", "w")
      outFile.write("#{settings.client_id} ")
      outFile.write("#{settings.private_key}")
      outFile.close
    end

    file = nil

    # get document by file GUID
    case settings.source
    when 'guid'
      file = GroupDocs::Storage::File.new({:guid => settings.file_id})
    when 'local'
      # construct path
      filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
      # open file
      File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
      # make a request to API using client_id and private_key
      file = GroupDocs::Storage::File.upload!(filepath, {}, client_id: settings.client_id, private_key: settings.private_key)
    when 'url'
      file = GroupDocs::Storage::File.upload_web!(settings.url, client_id: settings.client_id, private_key: settings.private_key)
    else
      raise "Wrong GUID source."
    end



    message = "No file with such GUID"
    unless file.nil?

      document = file.to_document
      # convert file
      convert = document.convert!(settings.convert_type, {:callback=>settings.callback}, {:client_id => settings.client_id, :private_key => settings.private_key})
      sleep(10)

      original_document = convert.documents!({:client_id => settings.client_id, :private_key => settings.private_key})
      # TODO: add Exception if not enough time for convertation
      guid = original_document[:inputs].first.outputs.first.guid
      
  
      if guid
        message = ""
      end
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample18, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :fileId => file.guid, :converted => guid, :callback => settings.callback, :message => message, :err => err }
end
