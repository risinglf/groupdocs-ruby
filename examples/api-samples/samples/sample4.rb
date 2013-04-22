# GET request
get '/sample4' do
  haml :sample4
end

# POST request
post '/sample4' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:file_id]
  set :url, params[:url]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty?

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})
    file = ''

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

    # download file
    dowloaded_file = file.download!(File.dirname(__FILE__), { :client_id => settings.client_id, :private_key => settings.private_key})
    unless dowloaded_file.empty?
      massage = "<font color='green'>File was downloaded to the <font color='blue'>#{dowloaded_file}</font> folder</font> <br />"
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample4, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :file_id => settings.file_id, :massage => massage, :err => err }
end
