# GET request
get '/sample19' do
  haml :sample19
end

# POST request
post '/sample19/compere_callback' do
  # Set download path
  downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"

  # Get callback request
  data = JSON.parse(request.body.read)
  begin
    raise 'Empty params!' if data.empty?
    source_id = nil
    client_id = nil
    private_key = nil

    # Get value of SourceId
    data.each do |key, value|
      if key == 'SourceId'
        source_id = value
      end
    end

    # Get private key and client_id from file user_info.txt
    if File.exist?("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = File.read("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = contents.split(' ')
      client_id = contents.first
      private_key = contents.last
    end

    # Create Job instance
    job = GroupDocs::Job.new({:id => source_id})

    # Get document by job id
    documents = job.documents!({:client_id => client_id, :private_key => private_key})

    # Download converted file
    documents[:inputs].first.outputs.first.download!(downloads_path, {:client_id => client_id, :private_key => private_key})

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
get '/sample19/downloads/:filename' do |filename|
  # Send file with header to download it
  send_file "#{File.dirname(__FILE__)}/../public/downloads/#{filename}", :filename => filename, :type => 'Application/octet-stream'
end

# POST request
post '/sample19' do
  # Set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :sourceFileId, params[:sourceFileId]
  set :targetFileId, params[:targetFileId]
  set :callbackUrl, params[:callbackUrl]

  # Set download path
  downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"

  # Remove all files from download directory or create folder if it not there
  if File.directory?(downloads_path)
    Dir.foreach(downloads_path) { |f| fn = File.join(downloads_path, f); File.delete(fn) if f != '.' && f != '..' }
  else
    Dir::mkdir(downloads_path)
  end

  begin

    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.sourceFileId.empty? or settings.targetFileId.empty?

    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
    end

    # Write client and private key to the file for callback job
    if settings.callbackUrl
      out_file = File.new("#{File.dirname(__FILE__)}/../public/user_info.txt", 'w')
      # white space is required
      out_file.write("#{settings.client_id} ")
      out_file.write("#{settings.private_key}")
      out_file.close
    end

    # Make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {})

    source_document = ''
    target_document = ''

    # Get source and target documents by file ID
    files_list.each do |element|
      if element.respond_to?('guid') == true and element.guid == settings.sourceFileId
        source_document = element
      end
      if element.respond_to?('guid') == true and element.guid == settings.targetFileId
        target_document = element
      end
    end

    unless source_document.instance_of? String and target_document.instance_of? String

      info = source_document.to_document.compare!(target_document.to_document, settings.callbackUrl)
      sleep(6)

      # Get job by ID
      job = GroupDocs::Job.new(id: info.id)
      # Get all job documents
      documents = job.documents!()
      # Get compared file giud
      guid = documents[:outputs].first.file.guid
      url = "https://apps.groupdocs.com/document-viewer/embed/#{guid}"
      # Add the signature to url request
      iframe = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url
      # Construct result iframe
      iframe = "<iframe src='#{iframe}' frameborder='0' width='100%' height='600'></iframe>"

    end

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample19, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :sourceFileId => settings.sourceFileId, :targetFileId => settings.targetFileId, :callbackUrl => settings.callbackUrl, :iframe => iframe, :err => err}
end
