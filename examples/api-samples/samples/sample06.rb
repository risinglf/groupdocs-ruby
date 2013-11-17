# GET request
get '/sample06' do
  haml :sample06
end

# POST request
post '/sample06' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :base_path, params[:base_path]
  require 'net/http'

  begin
    # Check required variables
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end


    # Construct file path and open file
    file_one_path = "#{File.dirname(__FILE__)}/#{params[:document][:filename]}"
    File.open(file_one_path, 'wb') { |f| f.write(params[:document][:tempfile].read) }


    # Create new file
    file_one = GroupDocs::Storage::File.new(name: params[:document][:filename], local_path: file_one_path)
    document_one = file_one.to_document

    # Construct signature path and open file
    signature_one_path = "#{Dir.tmpdir}/#{params[:signature][:filename]}"
    File.open(signature_one_path, 'wb') { |f| f.write(params[:signature][:tempfile].read) }

    # Add signature to file using API
    signature_one = GroupDocs::Signature.new(name: params[:signature][:filename], image_path: signature_one_path)
    signature_one.position = {top: 0.83319, left: 0.72171, width: 100, height: 40}


    # Make a request to API using client_id and private_key
    signed_documents = GroupDocs::Document.sign_documents!([document_one], [signature_one], {})
    sleep(5)

    # Get the document guid
    document = GroupDocs::Signature.sign_document_status!(signed_documents)

    # Create request from servers
    case settings.base_path

    when 'https://stage-api-groupdocs.dynabic.com'
      url = "http://stage-apps-groupdocs.dynabic.com/document-viewer/embed/#{document.guid}"

    when 'https://dev-api-groupdocs.dynabic.com'
      url = "http://dev-apps-groupdocs.dynabic.com/document-viewer/embed/#{document.guid}"
    else
      url = "https://apps.groupdocs.com/document-viewer/embed/#{document.guid}"
    end

    # Add the signature to url request
    iframe = GroupDocs::Api::Request.new(:path => url).prepare_and_sign_url

    # Generate result
    if signed_documents
      iframe = "<iframe src='#{iframe}' frameborder='0' width='720' height='600'></iframe>"
    end

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample06, :locals => {:client_id => settings.client_id, :private_key => settings.private_key, :iframe => iframe, :err => err}
end