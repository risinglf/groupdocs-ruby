# GET request
get '/sample35' do
  haml :sample35
end





# POST request
post '/sample35' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :source, params[:source]
  set :file_id, params[:fileId]
  set :url, params[:url]
  set :path, params[:base_path]

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # optionally specify API server and version
      groupdocs.api_server = settings.path # default is 'https://api.groupdocs.com'   https://dev-api-groupdocs.dynabic.com/v2.0
      groupdocs.api_version = '2.0' # default is '2.0'
    end

    # get document by file GUID
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
    fields = document.fields!()


    #
    html = ''
    fields.map do |e|
      if e.type == 'Text'
        signature = "<label for=#{e.name}>#{e.name} #{e.mandatory == false ? '<span class="optional">(Optional)</span>' : '<span class="optional">(Required)</span>'}</label><br/><input type='text' name='#{e.name}' id=''></input><br/>"
        html << signature
      end

      if e.type == 'Radio'
        radio = "<label for=#{e.name}>#{e.name} #{e.mandatory == false ? '<span class="optional">(Optional)</span>' : '<span class="optional">(Required)</span>'}</label><br/><input type='radio' name='#{e.type}' id=''></input><br/>"
        html << radio
      end

      if e.type == 'CheckBox'
        checkbox = "<label for=#{e.name}>#{e.name} #{e.mandatory == false ? '<span class="optional">(Optional)</span>' : '<span class="optional">(Required)</span>'}</label><br/><input type='checkbox' name='#{e.type}' id=''></input><br/>"
        html << checkbox
      end

    end



  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample35, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :base_path => settings.path, :fileId => document.file.guid, :html => html,  :err => err}
end

get '/sample35/check' do
  haml :sample35
end


post '/sample35/check' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :path, params[:base_path]
  set :file_id, params[:fileId]

  begin

    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # optionally specify API server and version
      groupdocs.api_server = settings.path # default is 'https://api.groupdocs.com'
      groupdocs.api_version = '2.0' # default is '2.0'
    end


    #TODO:
    #Merge template PDF FIle with the data provided via dinamically created HTML form.

    # Create instance of File
    #document = GroupDocs::Storage::File.new({:guid => settings.file_id}).to_document
    # Create datasource with fields
    #datasource = GroupDocs::DataSource.new

    # Get arry of document's fields
    #fields = document.fields!()

    # Create Field instance and fill the fields
    #datasource.fields = fields.map do |field|
     # if field.name == 'Text1'
      # field =  GroupDocs::DataSource::Field.new(name: field.name, type: :text, values: [params[:Text1]])

     # end
    #end


     # Adds datasource.
    #datasource.add!()


     # Creates new job to merge datasource into document.
    #job = document.datasource!(datasource, {:new_type => 'pdf'})
    #sleep 10 # wait for merge and convert

     # Returns an hash of input and output documents associated to job.
    #document = job.documents!()

     # Download file
    #document[:inputs][0].outputs[0].download!("#{File.dirname(__FILE__)}/../public/downloads")

     # Set converted document GUID
    #guid = document[:inputs][0].outputs[0].guid
     # Set converted document Name
    #file_name = document[:inputs][0].outputs[0].name

    # Set iframe with document GUID or raise an error
    if settings.path == 'https://stage-api-groupdocs.dynabic.com'
      iframe = "<iframe width='100%' height='600' frameborder='0' src='http://stage-apps-groupdocs.dynabic.com/document-viewer/#{settings.file_id}'></iframe>"
    end

      if settings.path == 'https://dev-api-groupdocs.dynabic.com'
        iframe = "<iframe width='100%' height='600' frameborder='0' src='http://dev-apps-groupdocs.dynabic.comdocument-viewer/#{settings.file_id}'></iframe>"
      end




  rescue Exception => e
    err = e.message
  end

  haml :sample35, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :iframe => iframe,  :err => err}
end