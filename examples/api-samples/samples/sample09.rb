# GET request
get '/sample09' do
  haml :sample09
end

# POST request
post '/sample09' do
  # Set variables
  set :file_id, params[:fileId]
  set :width, params[:width]
  set :height, params[:height]
  set :source, params[:source]
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :check, params[:check]
  set :url, params[:url]
  set :base_path, params[:base_path]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.width.empty? or settings.height.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
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
      case settings.base_path
      when 'https://stage-api-groupdocs.dynabic.com'
      url = "http://stage-apps-groupdocs.dynabic.com/document-viewer/embed/#{file.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
      when 'https://dev-api-groupdocs.dynabic.com'
        url = "http://dev-apps-groupdocs.dynabic.com/document-viewer/embed/#{file.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
      else
        url = "https://apps.groupdocs.com/document-viewer/embed/#{file.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
      end

    when 'annotation'
      case settings.base_path
      when 'https://stage-api-groupdocs.dynabic.com'
        url = "http://stage-apps-groupdocs.dynabic.com/document-annotation2/embed/#{file.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
      when 'https://dev-api-groupdocs.dynabic.com'
        url = "http://dev-apps-groupdocs.dynabic.com/document-annotation2/embed/#{file.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
      else
        url = "https://apps.groupdocs.com/document-annotation2/embed/#{file.guid}?frameborder='0' width='#{settings.width}' height='#{settings.height}'"
      end
    end

    # Construct result string
    url = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample09, :locals => {:guid => file.guid, :width => settings.width, :height => settings.height, :v_url => url, :err => err}
end
