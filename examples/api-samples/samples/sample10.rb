# GET request
get '/sample10' do
  haml :sample10
end

# POST request
post '/sample10' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :guid, params[:fileId]
  set :email, params[:email]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.guid.empty? or settings.email.empty?

    # get document by file GUID
    file = nil
    case settings.source
    when 'guid'
      file = GroupDocs::Storage::File.new({:guid => settings.guid})
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

    # Share document. Make a request to API using client_id and private_key
    shared = file.to_document.sharers_set!(settings.email.split(" "), { :client_id => settings.client_id, :private_key => settings.private_key});

    # result
    if shared
      shared_emails = settings.email
    end
  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample10, :locals => { :client_id => settings.client_id, :private_key => settings.private_key, :guid => settings.guid, :email=>settings.email, :shared => shared_emails, :err => err }
end
