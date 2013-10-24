# GET request
get '/sample21' do
  haml :sample21
end

# POST request
post '/sample21/signature_callback' do
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
    job = GroupDocs::Signature::Envelope.new({:id => source_id})

    # Get document by job id
    documents = job.documents!({}, {:client_id => client_id, :private_key => private_key})

    # Download converted file
    documents[0].file.download!(downloads_path, {:client_id => client_id, :private_key => private_key})

  rescue Exception => e
    err = e.message
  end
end


# GET request
get '/sample21/check' do

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
get '/sample21/downloads/:filename' do |filename|
  # Send file with header to download it
  send_file "#{File.dirname(__FILE__)}/../public/downloads/#{filename}", :filename => filename, :type => 'Application/octet-stream'
end

# POST request
post '/sample21' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :email, params[:email]
  set :name, params[:name]
  set :lastName, params[:lastName]
  set :file, params[:file]
  set :callback, params[:callback]
  begin

    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.email.empty? or settings.name.empty? or settings.lastName.empty? or settings.file.nil?

    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
    end

    # Write client and private key to the file for callback job
    if settings.callback
      out_file = File.new("#{File.dirname(__FILE__)}/../public/user_info.txt", 'w')
      # white space is required
      out_file.write("#{settings.client_id} ")
      out_file.write("#{settings.private_key}")
      out_file.close
    end

    # construct path
    filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
    # open file
    File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
    # upload file
    file = GroupDocs::Storage::File.upload!(filepath, {})

    # create envelope using user id and entered by user name
    envelope = GroupDocs::Signature::Envelope.new
    envelope.name = params[:file][:filename]
    envelope.email_subject = 'Sing this!'
    envelope.create!({})

    # Add uploaded document to envelope
    envelope.add_document!(file.to_document, {})

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
    field.name = 'Field'

    # Add field to envelope
    envelope.add_field!(field, document[0], recipient, {})


    # Send envelop
    envelope.send!(settings.callback)

    # Add the signature to url request
    url = "https://apps.groupdocs.com/signature/signembed/#{envelope.id}/#{recipient.id}"
    iframe = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url
    # Make iframe
    iframe = "<iframe src='#{iframe}' frameborder='0' width='720' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample21, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :email => settings.email, :name => settings.name, :lastName => settings.lastName, :iframe => iframe, :err => err, :callback => settings.callback,}
end
