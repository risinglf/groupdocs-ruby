# GET request
get '/sample9' do
  haml :sample9
end

# POST request
post '/sample9' do
  # set variables
  set :file_id, params[:fileId]
  set :width, params[:width]
  set :height, params[:height]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.guid.empty? or settings.width.empty? or settings.height.empty?

    # get document by file GUID
    file = nil
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

    # construct result string
    v_url = "https://apps.groupdocs.com/document-viewer/embed/#{file.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
      
    if v_url
      v_url = v_url
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample9, :locals => { :guid => settings.guid, :width => settings.width, :height => settings.height, :v_url=>v_url, :err => err }
end
