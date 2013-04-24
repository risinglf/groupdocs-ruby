# GET request
get '/sample25' do
  haml :sample25
end

# POST request
post '/sample25' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  
  # Set download path
  downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"

  # Remove all files from download directory or create folder if it not there
  if File.directory?(downloads_path)
    Dir.foreach(downloads_path) { |f| fn = File.join(downloads_path, f); File.delete(fn) if f != '.' && f != '..' }
  else
    Dir::mkdir(downloads_path)
  end

  begin
    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # construct path
    file_path = "#{Dir.tmpdir}/#{params[:file][:filename]}"
    # open file
    File.open(file_path, 'wb') { |f| f.write(params[:file][:tempfile].read) }
    # make a request to API using client_id and private_key
    file = GroupDocs::Storage::File.upload!(file_path, {}, {:client_id => settings.client_id, :private_key => settings.private_key})

    document = file.to_document

    # create datasource with fields
    datasource = GroupDocs::DataSource.new

    fields = document.fields!({:client_id => settings.client_id, :private_key => settings.private_key})

    datasource.fields = fields.map { |field| GroupDocs::DataSource::Field.new(name: field.name, type: :text, values: %w(value1 value2)) }

    datasource.add!({:client_id => settings.client_id, :private_key => settings.private_key})


    # merge and convert
    job = document.datasource!(datasource, {:new_type => 'pdf'}, {:client_id => settings.client_id, :private_key => settings.private_key})
    sleep 10 # wait for merge and convert

    document = job.documents!({:client_id => settings.client_id, :private_key => settings.private_key})
    document[:inputs][0].outputs[0].download!("#{File.dirname(__FILE__)}/../public/downloads", {:client_id => settings.client_id, :private_key => settings.private_key})

    # Get converted document GUID
    guid = document[:inputs][0].outputs[0].guid
    file_name = document[:inputs][0].outputs[0].name

    # Set iframe with document GUID or raise an error
    if guid
      iframe = "<iframe width='100%' height='600' frameborder='0' src='https://apps.groupdocs.com/document-viewer/embed/#{guid}'></iframe>"
    else
      raise 'File was not converted'
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample25, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :iframe => iframe, :file_name => file_name,  :err => err}
end
