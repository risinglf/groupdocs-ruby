# GET request
get '/sample35' do
  haml :sample35
end


# POST request
post '/sample35' do
  # Set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :source, params[:source]
  set :file_id, params[:fileId]
  set :url, params[:url]
  set :path, params[:basePath]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    if settings.path.empty? then settings.path == 'https://api.groupdocs.com' end
    # clean version if it contains
    path = settings.path.gsub(/\/v2.0/, '')

    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # optionally specify API server and version
      groupdocs.api_server = path # default is 'https://api.groupdocs.com'   https://dev-api-groupdocs.dynabic.com/v2.0

    end


    # Get document by file GUID
    case settings.source
    when 'guid'
      # Create instance of File
      file = GroupDocs::Storage::File.new({:guid => settings.file_id})
    when 'local'
      # Construct path
      file_path = "#{Dir.tmpdir}/#{params[:file][:filename]}"
      # Open file
      File.open(file_path, 'wb') { |f| f.write(params[:file][:tempfile].read) }
      # Make a request to API using client_id and private_key
      file = GroupDocs::Storage::File.upload!(file_path, {})
    when 'url'
      # Upload file from defined url
      file = GroupDocs::Storage::File.upload_web!(settings.url)
    else
      raise 'Wrong GUID source.'
    end

    # Raise exception if something went wrong
    raise 'No such file' unless file.is_a?(GroupDocs::Storage::File)


    # Make GroupDocs::Storage::Document instance
    document = file.to_document
    # Get array of document's fields
    fields = document.fields!

    # Create the fields for form
    html = ''
    fields.map do |e|

      case e.type
      when 'Text'
        signature = "<br/><label for='#{e.name}'>#{e.name} #{e.mandatory == false ? '<span class="optional">(Optional)</span>' : '<span class="optional">(Required)</span>'}</label><br/><input type='text' name='#{e.name}'></input><br/><br/>"
        html << signature
      when 'RadioButton'
        i = 0
        html.scan(e.name).empty? ? '' : i += 1
        radio = "<br/><label for='#{e.name}'>#{e.name} #{e.mandatory == false ? '<span class="optional">(Optional)</span>' : '<span class="optional">(Required)</span>'}</label><br/><input type='radio' name='#{e.name}' value='#{i}' ></input><br/><br/>"
        html << radio
      when 'Checkbox'
        checkbox = "<br/><label for='#{e.name}'>#{e.name} #{e.mandatory == false ? '<span class="optional">(Optional)</span>' : '<span class="optional">(Required)</span>'}</label><br/><input type='checkbox' name='#{e.name}' ></input><br/><br/>"
        html << checkbox
      when 'Combobox'
        combobox = "<br/><label for='#{e.name}'>#{e.name} #{e.mandatory == false ? '<span class="optional">(Optional)</span>' : '<span class="optional">(Required)</span>'}</label><br/><select name='#{e.name}'>"
        e.acceptableValues.each { |e| combobox << "<option name='#{e}'>#{e}</option>"}
        combobox << "</select><br/><br/>"
        html << combobox
      when 'Listbox'
        listbox = "<br/><label for='#{e.name}'>#{e.name} #{e.mandatory == false ? '<span class="optional">(Optional)</span>' : '<span class="optional">(Required)</span>'}</label><br/><select multiple name='#{e.name}[]'>"
        e.acceptableValues.each { |e| listbox << "<option name='#{e}'>#{e}</option>"}
        listbox << "</select><br/><br/>"
        html << listbox
      end

    end


  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample35, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :base_path => settings.path, :fileId => document.file.guid, :html => html, :err => err}
end

# GET request
get '/sample35/check' do
  haml :sample35
end

# POST request
post '/sample35/check' do
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :path, params[:basePath]
  set :file_id, params[:fileId]

  begin

    if settings.path.empty? then settings.path == 'https://api.groupdocs.com' end

    #clean version if it contains
    path = settings.path.gsub(/\/v2.0/, '')

    # Get document by file GUID
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # optionally specify API server and version
      groupdocs.api_server = path # default is 'https://api.groupdocs.com'
      groupdocs.api_version = '2.0' # default is '2.0'
    end


    #TODO:
    #Merge template PDF FIle with the data provided via dynamically created HTML form.

    # Create instance of File
    document = GroupDocs::Storage::File.new({:guid => settings.file_id}).to_document

    # Create datasource with fields
    datasource = GroupDocs::DataSource.new

    # Get array of document's fields
    fields = document.fields!()

    # Get unique fields
    fields = fields.uniq{ |f| f.name }

    datasource.fields = []

    # Create Field instance and fill the fields
    fields.each do |field|
      if field.type == 'Text'
        datasource.fields << GroupDocs::DataSource::Field.new(name: field.name, type: :text, values: [params[field.name.to_sym]])
      end

      if field.type == "RadioButton" && params[field.name.to_sym]
        datasource.fields << GroupDocs::DataSource::Field.new(name: field.name, type: 'integer', values: [params[field.name.to_sym]])

      end

      if field.type == "Checkbox" && params[field.name.to_sym] == 'on'
        datasource.fields << GroupDocs::DataSource::Field.new(name: field.name, type: 'boolean', values: [true])
      end

      if field.type == "Combobox" && params[field.name.to_sym]
          i = 0
          value = nil
          field.acceptableValues.each do |e|
            e == params[field.name] ? value = i : ''
            i += 1
          end

        datasource.fields << GroupDocs::DataSource::Field.new(name: field.name, type: 'integer', values: [value])
      end

      if field.type == "Listbox" && params[field.name.to_sym]
          i = 0
          value = nil
          field.acceptableValues.each do |e|
            e == params[field.name] ? value = i : ''
            i += 1
          end
        datasource.fields << GroupDocs::DataSource::Field.new(name: field.name, type: 'integer', values: [value])

      end

    end

    # Adds datasource.
    datasource.add!()

    # Creates new job to merge datasource into document.
    job = document.datasource!(datasource, {:new_type => 'pdf'})

    i = 0
    # Checks status of Job.
    while i<5 do
      sleep(5)
      job_status = GroupDocs::Job.get!(job.id)
      break if job_status.status == :archived
      i += 1
    end

    # Returns an hash of input and output documents associated to job.
    document = job.documents!()

    # Set converted document GUID
    guid = document[:inputs][0].outputs[0].guid

    case path

    when 'https://stage-api-groupdocs.dynabic.com'
      iframe = "<iframe width='100%' height='600' frameborder='0' src='http://stage-apps-groupdocs.dynabic.com/document-viewer/embed/#{guid}'></iframe>"
    when 'https://dev-api-groupdocs.dynabic.com'
      iframe = "<iframe width='100%' height='600' frameborder='0' src='http://dev-apps-groupdocs.dynabic.com/document-viewer/embed/#{guid}'></iframe>"
    else
      iframe = "<iframe width='100%' height='600' frameborder='0' src='https://apps.groupdocs.com/document-viewer/embed/#{guid}'></iframe>"
    end


  rescue Exception => e
    err = e.message
  end

  haml :sample35, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :iframe => iframe, :err => err}
end