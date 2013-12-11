# Route to handle url "/sample37"
get '/sample37' do
  haml :sample37
end

# Route to handle url "/sample37/signature_callback". It handles callback request from API server
post '/sample37/signature_callback' do
  # Get  json data from callback request
  data = JSON.parse(request.body.read)  
  begin 
    
    raise 'Empty params!' if data.empty?

  # Set variables from json data
	source_id = data['SourceId']    
  event_type = data['EventType']

  # Set variables
  client_id = nil
  private_key = nil
	
	return if event_type != 'JobCompleted'
	
	# Set download path
	downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"
	
	 # Get private key and client_id from file user_info.txt
	if File.exist?("#{File.dirname(__FILE__)}/../public/user_info.txt")
	  contents = File.read("#{File.dirname(__FILE__)}/../public/user_info.txt")
	  contents = contents.split(' ')
	  client_id = contents[0]
	  private_key = contents[1]
	end

    # Get Envelope instance
    envelope = GroupDocs::Signature::Envelope.get!(source_id, {:client_id => client_id, :private_key => private_key})

    # Get document by envelope
    envelope.signed_documents!(downloads_path, {:client_id => client_id, :private_key => private_key})
   

  rescue Exception => e
    err = e.message
  end
end


# Route to handle url "/sample37/check"
get '/sample37/check' do

  # Check is there download directory
  unless File.directory?("#{File.dirname(__FILE__)}/../public/downloads")
    return 'Directory was not found.'
  end

  # Get file name from download directory
  name = nil
 
  i = 0

  # Checking, if file exist
    while i<10 do
      sleep(5)  	  
    Dir.entries("#{File.dirname(__FILE__)}/../public/downloads").each do |file|	
      name = file if file != '.' && file != '..'	
    end	  
      break if name
      i += 1
    end

  name
end

# Route to handle url "/sample37/downloads"
get '/sample37/downloads/:filename' do |filename|
  # Send file with header to download it
  send_file "#{File.dirname(__FILE__)}/../public/downloads/#{filename}", :filename => filename, :type => 'Application/octet-stream'
end

# Route to handle url "/sample37". It creates new envelope
post '/sample37' do
  # Set variables from form
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :email, params[:email]
  set :name, params[:name]
  set :lastName, params[:lastName]
  set :fileId, params[:fileId]
  set :callback, params[:callback]
  set :base_path, params[:basePath]
  set :url, params[:url]
  set :source, params[:source]

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
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.email.empty? or settings.name.empty? or settings.lastName.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # Write client and private key to the file for callback job
    if settings.callback
      out_file = File.new("#{File.dirname(__FILE__)}/../public/user_info.txt", 'w')
      # white space is required
      out_file.write("#{settings.client_id} ")
      out_file.write("#{settings.private_key}")
      out_file.close
    end

    file = nil
    # get document by file GUID
    case settings.source
      when 'guid'
        # Create instance of File
        file = GroupDocs::Storage::File.new({:guid => settings.fileId}).to_document.metadata!()
        file = file.last_view.document.file.to_document
      when 'local'
        # construct path
        file_path = "#{Dir.tmpdir}/#{params[:file][:filename]}"

        # open file
        File.open(file_path, 'wb') { |f| f.write(params[:file][:tempfile].read) }
        # make a request to API using client_id and private_key
        file = GroupDocs::Storage::File.upload!(file_path, {}).to_document
      when 'url'
        # Upload file from defined url
        file = GroupDocs::Storage::File.upload_web!(settings.url).to_document
      else
        raise 'Wrong GUID source.'
    end

    name = file.name
    # create envelope using user id and entered by user name
    envelope = GroupDocs::Signature::Envelope.new
    envelope.name = file.name
    envelope.email_subject = 'Sing this!'
    envelope.create!({})

    # Add uploaded document to envelope
    envelope.add_document!(file, {})

    # Get role list for current user
    roles = GroupDocs::Signature::Role.get!({})

    # Create new recipient
    recipient = GroupDocs::Signature::Recipient.new
    recipient.email = settings.email
    recipient.first_name = settings.name
    recipient.last_name = settings.lastName
    recipient.role_id = roles.detect { |role| role.name == 'Signer' }.id

    # Add recipient to envelope
    add = envelope.add_recipient!(recipient)

    # Get recipient id
    recipient.id = add[:recipient][:id]

    # Get document id
    document = envelope.documents!({})


    # Get field and add the location to field
    field = GroupDocs::Signature::Field.get!({}).detect { |f| f.type == :signature }
    field.location = {:location_x => 0.15, :location_y => 0.73, :location_w => 150, :location_h => 50, :page => 1}
    field.name = 'EMPLOYEE SIGNATURE'

    # Add field to envelope
    envelope.add_field!(field, document[0], recipient, {})

    # Send envelop
    envelope.send!({:callbackUrl => settings.callback})

    #Get url from request
    case settings.base_path

      when 'https://stage-api-groupdocs.dynabic.com'
        url = "http://stage-apps-groupdocs.dynabic.com/signature/signembed/#{envelope.id}/#{recipient.id}"
      when 'https://dev-api-groupdocs.dynabic.com'
        url = "http://dev-apps-groupdocs.dynabic.com/signature/signembed/#{envelope.id}/#{recipient.id}"
      else
        url = "https://apps.groupdocs.com/signature/signembed/#{envelope.id}/#{recipient.id}"
    end


    iframe = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url
    # Make iframe
    iframe = "<iframe src='#{iframe}' frameborder='0' width='720' height='600'></iframe>"
    message = "<p>File was uploaded to GroupDocs. Here you can see your <strong>#{name}</strong> file in the GroupDocs Embedded Viewer.</p>"
  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample37, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :email => settings.email, :name => settings.name, :lastName => settings.lastName, :iframe => iframe, :massage => message, :err => err, :callback => settings.callback,}
end
