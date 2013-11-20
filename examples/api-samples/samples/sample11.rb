# GET request
get '/sample11' do
  haml :sample11
end

# POST request
post '/sample11' do
  # Set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :file_id, params[:fileId]
  set :annotation_type, params[:annotationType]
  set :annotation_id, params[:annotationId]
  set :base_path, params[:basePath]

  begin

    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty? or settings.annotation_type.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    if settings.annotation_id != ''

      file = GroupDocs::Storage::File.new({:guid => settings.file_id}).to_document
      annotation = file.annotations!()

      # Remove annotation from document
      remove = annotation.last.remove!()
      message = "You delete the annotation id = #{remove[:guid]} "
    else
    # Annotation types
    types = {:text => "0", :area => "1", :point => "2"}


    # Required parameters
    all_params = all_params = ['annotation_type', 'box_x', 'box_y', 'text']

    # Added required parameters depends on  annotation type ['text' or 'area']
    if settings.annotation_type == 'text'
      all_params = all_params | ['box_width', 'box_height', 'annotationPosition_x', 'annotationPosition_y', 'range-position', 'range-length']
    elsif settings.annotation_type == 'area'
      all_params = all_params | ['box_width', 'box_height']
    end

    # Checking required parameters
    all_params.each do |param|
      raise 'Please enter all required parameters' if params[param].empty?
    end

    # Make a request to API using client_id and private_key
    files_list = GroupDocs::Storage::Folder.list!('/', {})

    document = ''

    # Get document by file ID
    files_list.each do |element|
      if element.respond_to?('guid') == true and element.guid == settings.file_id
        document = element
      end
    end

    unless document.instance_of? String

      # Start create new annotation
      annotation = GroupDocs::Document::Annotation.new(document: document.to_document)


      info = nil
      # Construct requestBody depends on annotation type
      # Text annotation
      if settings.annotation_type == 'text'
        annotation.box = GroupDocs::Document::Rectangle.new ({x: params['box_x'], y: params['box_y'], width: params['box_width'], height: params['box_height']})
        annotation.annotationPosition = {x: params['annotationPosition_x'], y: params['annotationPosition_y']}
        range = {position: params['range-position'], length: params['range-length']}
        info = {:box => annotation_box, :annotationPosition => annotation_annotationPosition, :range => range, :type => types[settings.annotation_type.to_sym], :replies => [{:text => params['text']}]}
        # Area annotation
      elsif settings.annotation_type == 'area'
        annotation_box = {x: params['box_x'], y: params['box_y'], width: params['box_width'], height: params['box_height']}
        annotation_annotationPosition = {x: 0, y: 0}
        info = {:box => annotation_box, :annotationPosition => annotation_annotationPosition, :type => types[settings.annotation_type.to_sym], :replies => [{:text => params['text']}]}
        # Point annotation
      elsif settings.annotation_type == 'point'
        annotation_box = {x: params['box_x'], y: params['box_y'], width: 0, height: 0}
        annotation_annotationPosition = {x: 0, y: 0}

        info = {:box => annotation_box, :annotationPosition => annotation_annotationPosition, :type => types[settings.annotation_type.to_sym], :replies => [{:text => params['text']}] }
      end


      # Call create method
      annotation.create!(info)
      id = annotation.document.file.id
      # Get document guid
      guid = annotation.document.file.guid

      case settings.base_path

        when 'https://stage-api-groupdocs.dynabic.com'
          url = "http://stage-apps-groupdocs.dynabic.com/document-annotation2/embed/#{guid}"
        when 'https://dev-api-groupdocs.dynabic.com'
          url = "http://dev-apps-groupdocs.dynabic.com/document-annotation2/embed/#{guid}"
        else
          url = "http://apps.groupdocs.com/document-annotation2/embed/#{guid}"
      end

        #Add the signature in url
        url = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url
        # Set iframe with document GUID
        iframe = "<iframe src='#{url}' frameborder='0' width='720' height='600'></iframe>"

    end

    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample11, :locals => {:clientId => settings.client_id,
                              :privateKey => settings.private_key,
                              :fileId => settings.file_id,
                              :annotationType => settings.annotation_type,
                              :annotationId => id,
                              :annotationText => params['text'],
                              :err => err,
                              :iframe => iframe,
                              :message => message}
end