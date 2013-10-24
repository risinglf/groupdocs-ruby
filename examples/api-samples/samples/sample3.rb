# GET request
get '/sample3' do
  haml :sample3
end

# POST request
post '/sample3' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :source, params[:source]
  set :url, params[:url]
  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
    end

    # Get document by file GUID
    case settings.source

    when 'file'
      # construct path
      filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
      # open file
      File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
      # make a request to API using client_id and private_key
      file = GroupDocs::Storage::File.upload!(filepath, {})

    when 'url'

      # Upload file from defined url
      file = GroupDocs::Storage::File.upload_web!(settings.url)
    else raise 'Wrong GUID source.'
    end

    url = "https://apps.groupdocs.com/document-viewer/embed/#{file.guid}"
    # Add the signature in url
    url = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url

    # Set iframe with document GUID
    iframe = "<iframe src='#{url}' frameborder='0' width='720' height='600'></iframe>"

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample3, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :iframe => iframe, :err => err}
end
