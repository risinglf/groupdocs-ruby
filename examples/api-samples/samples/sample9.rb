# GET request
get '/sample9' do
  haml :sample9
end

# POST request
post '/sample9' do
  # Set variables
  set :file_id, params[:fileId]
  set :width, params[:width]
  set :height, params[:height]
  set :source, params[:source]
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :check, params[:check]
  set :url, params[:url]
  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.width.empty? or settings.height.empty?

    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
    end

    # Get document by file GUID
    file = nil
    case settings.source
    when 'guid'
      file = GroupDocs::Storage::File.new({:guid => settings.file_id})
    when 'local'
      # Construct path
      filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
      # Open file
      File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
      # Make a request to API using client_id and private_key
      file = GroupDocs::Storage::File.upload!(filepath, {})
    when 'url'
      file = GroupDocs::Storage::File.upload_web!(settings.url)
    else
      raise 'Wrong GUID source.'
    end
     url = nil
    case settings.check
    when 'viewer'
      url = "https://apps.groupdocs.com/document-viewer/embed/#{file.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
    when 'annotation'
      url = "https://apps.groupdocs.com/document-annotation2/embed/#{file.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
    end

    # Construct result string
    url = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample9, :locals => {:guid => file.guid, :width => settings.width, :height => settings.height, :v_url => url, :err => err}
end
