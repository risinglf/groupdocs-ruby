# GET request
get '/sample20' do
  haml :sample20
end

# POST request
post '/sample20' do
  # set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :resultFileId, params[:resultFileId]
  set :base_path, params[:basePath]

  begin

    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.resultFileId.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # construct new storage file
    file = GroupDocs::Storage::File.new(guid: settings.resultFileId)
    # construct new document
    document = GroupDocs::Document.new(file: file)
    # get compare changes
    changes = document.changes!()

    result = ''
    result += "<table class='border'>"
    result += "<tr><td><font color='green'>Change Name</font></td><td><font color='green'>Change</font></td></tr>"
    changes.each do |change|
      result += "<tr><td>id</td><td>#{change.id}</td></tr>"
      result += "<tr><td>type</td><td>#{change.type}</td></tr>"
      result += "<tr><td>text</td><td>#{change.text}</td></tr>"
      result += "<tr><td>page id</td><td>#{change.page[:Id]}</td></tr>"
      result += "<tr><td>page weight</td><td>#{change.page[:Width]}</td></tr>"
      result += "<tr><td>page height</td><td>#{change.page[:Height]}</td></tr>"
      result += "<tr><td>box x</td><td>#{change.box.x}</td></tr>"
      result += "<tr><td>box y</td><td>#{change.box.y}</td></tr>"
      result += "<tr><td>box weight</td><td>#{change.box.width}</td></tr>"
      result += "<tr><td>box height</td><td>#{change.box.height}</td></tr>"
      result += "<tr bgcolor='#808080'><td></td><td></td></tr>"
    end

    result += '</table>'

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample20, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :resultFileId => settings.resultFileId, :result => result, :err => err}
end
