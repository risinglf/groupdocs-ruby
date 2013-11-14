# GET request
get '/sample11' do
  haml :sample11
end

# POST request
post '/sample11' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:fileId]
  set :annotation_type, params[:annotation_type]
  set :annotation_id, params[:annotationId]
  begin

    # check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty? or settings.annotation_type.empty?
    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
    end

    if settings.annotation_id != ''
      annotation = GroupDocs::Document::Annotation.remove!(settings.annotation_id)
      message = "You delete the annotation id = #{annotation[:guid]} "
    else
    # Annotation types
    types = {:text => 0, :area => 1, :point => 2}

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

      annotation.type = types[settings.annotation_type]
      info = nil
      # Construct requestBody depends on annotation type
      # Text annotation
      if settings.annotation_type == 'text'
        annotation_box = {x: params['box_x'], y: params['box_y'], width: params['box_width'], height: params['box_height']}
        annotation_annotationPosition = {x: params['annotationPosition_x'], y: params['annotationPosition_y']}
        range = {position: params['range-position'], length: params['range-length']}
        info = {:box => annotation_box, :annotationPosition => annotation_annotationPosition, :range => range}
        # Area annotation
      elsif settings.annotation_type == 'area'
        annotation_box = {x: params['box_x'], y: params['box_y'], width: params['box_width'], height: params['box_height']}
        annotation_annotationPosition = {x: 0, y: 0}
        info = {:box => annotation_box, :annotationPosition => annotation_annotationPosition}
        # Point annotation
      elsif settings.annotation_type == 'point'
        annotation_box = {x: params['box_x'], y: params['box_y'], width: 0, height: 0}
        annotation_annotationPosition = {x: 0, y: 0}
        info = {:box => annotation_box, :annotationPosition => annotation_annotationPosition}
      end


        # Call create method
        annotation.create!(info)
        # Add annotation reply
        reply = GroupDocs::Document::Annotation::Reply.new(annotation: annotation)
        reply.text = params['text']
        reply.create!
        annotation_id = annotation.guid

        url = "http://apps.groupdocs.com/document-annotation2/embed/#{annotation.document.file.guid}?frameborder='0' width='720' height='600'"

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
  haml :sample11, :locals => {:userId => settings.client_id,
                              :privateKey => settings.private_key,
                              :fileId => settings.file_id,
                              :annotationType => settings.annotation_type,
                              :annotationId => annotation_id,
                              :annotationText => params['text'],
                              :err => err,
                              :iframe => iframe,
                              :message => message}
end