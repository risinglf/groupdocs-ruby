# GET request
get '/sample18' do
  haml :sample18
end

# POST request
post '/sample18' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:fileId]
  set :convert_type, params[:convert_type]

  begin
    # check required variables
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty?

    # make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})
    file = nil

    # get document by file ID
    files_list.each do |element|
      if element.respond_to?('guid') == true and element.guid == settings.file_id
        file = element
      end
    end

    message = "No file with such GUID"
    unless file.nil?

      document = file.to_document
      # convert file
      convert = document.convert!(settings.convert_type, {}, {:client_id => settings.client_id, :private_key => settings.private_key})
      sleep(10)

      original_document = convert.documents!({:client_id => settings.client_id, :private_key => settings.private_key})
      # TODO: add Exception if not enough time for convertation
      guid = original_document[:inputs].first.outputs.first.guid
      
      if guid
        iframe = "<iframe src='https://apps.groupdocs.com/document-viewer/embed/#{guid}' frameborder='0' width='100%' height='600'></iframe>"
        message = "<p>Converted file saved successfully."
      end
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample18, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :fileId => settings.file_id, :message => message, :iframe => iframe, :err => err }
end
