# GET request
get '/sample18' do
  haml :sample18
end

post '/sample18/test_callback' do
    downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"
    unless File.directory?(downloads_path)
      Dir::mkdir(downloads_path)
    else
      Dir.foreach(downloads_path) {|f| fn = File.join(downloads_path, f); File.delete(fn) if f != '.' && f != '..'}
    end

    SourceId = nil
    client_key = nil
    private_key = nil
    
    data = JSON.parse(request.body.read)
    data.each do |key, value|
      if key == 'SourceId'
        SourceId = value
      end
    end

    if File.exist?("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = File.read("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = contents.split(' ')
      client_key = contents.first
      private_key = contents.last
    end

    outFile = File.new("#{File.dirname(__FILE__)}/../public/downloads/signed", "w")
    outFile.write("private_key: #{private_key} \n")
    outFile.write("client_key: #{client_key} \n")
    outFile.write("SourceId: #{SourceId} \n")
    outFile.close

    job = GroupDocs::Job.new({:id=>SourceId})
    documents = job.documents!({:client_id => client_key, :private_key => private_key})
    tttt = documents[:inputs].first.file.download!(downloads_path, {:client_id => client_key, :private_key => private_key})

    outFile = File.new("#{File.dirname(__FILE__)}/../public/downloads/t", "w")
    outFile.write("documents: #{documents} \n")
    outFile.write("tttt: #{tttt} \n")
    outFile.close
end

# GET request to check if envelop was signed
get '/sample18/test_check' do
  if File.exist?("#{File.dirname(__FILE__)}/../public/downloads/signed")
    File.readlines("#{File.dirname(__FILE__)}/../public/downloads/signed").each do |line|
    end
  else 
    'not yet'
  end
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
    SourceId = nil
    client_key = nil
    private_key = nil


    data.each do |key, value|
      if key == 'SourceId'
        SourceId = value
      end
    end

    if File.exist?("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = File.read("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = contents.split(' ')
      client_key = contents.first
      private_key = contents.last
    end

    job = GroupDocs::Job.new({:id=>SourceId})
    documents = job.documents!({:client_id => client_key, :private_key => private_key})
    documents[:inputs].first.file.download!(downloads_path, {:client_id => client_key, :private_key => private_key})

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
    return name
  else
    return "File was not found."
  end
end


# POST request
post '/sample18' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:fileId]
  set :convert_type, params[:convert_type]
  set :callback, params[:callback]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty?
   
    if settings.callback[0]
      outFile = File.new("#{File.dirname(__FILE__)}/../public/user_info.txt", "w")
      outFile.write("#{settings.client_id} ")
      outFile.write("#{settings.private_key}")
      outFile.close
    end

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})
    file = nil

    # get document by file ID
    files_list.each do |element|
      if element.respond_to?('guid') == true and element.guid == settings.file_id
        file = element
      end
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
        iframe = "<iframe src='https://apps.groupdocs.com/document-viewer/embed/#{guid}' frameborder='0' width='100%' height='600'></iframe>"
        message = "<p>Converted file saved successfully."
      end
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample18, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :fileId => settings.file_id, :message => message, :iframe => iframe, :err => err }
end
