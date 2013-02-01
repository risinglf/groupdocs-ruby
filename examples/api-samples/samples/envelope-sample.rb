get '/envelope-sample' do
  haml :envelope_sample
end

get '/envelope-sample/sign' do
  outFile = File.new("signed", "w")
  outFile.close
end

get '/envelope-sample/check' do
  if File.exist?('signed')
    File.delete('signed')
    'true'
  else 
    'false'
  end
end

post '/envelope-sample' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]

  begin
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?

    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = params[:client_id]
      groupdocs.private_key = params[:private_key]
    end
     
    # upload document
    filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
    File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
    file = GroupDocs::Storage::File.upload!(filepath, {}, client_id: settings.client_id, private_key: settings.private_key)
    document = file.to_document
     
    # create envelope
    envelope = GroupDocs::Signature::Envelope.new
    envelope.name = "Envelope"
    envelope.email_subject = "Sing this!"
    envelope.create!
     
    # add document to envelope
    envelope.add_document! document
     
    # update document object after it's created
    document = envelope.documents!.first
     
    # add new recipient to envelope
    roles = GroupDocs::Signature::Role.get!
    recipient = GroupDocs::Signature::Recipient.new
    recipient.email = 'john@smith.com'
    recipient.first_name = 'John'
    recipient.last_name = 'Smith'
    recipient.role_id = roles.detect { |role| role.name == "Signer" }.id
    envelope.add_recipient! recipient
     
    # update recipient object after it's created
    recipient = envelope.recipients!.first
    
    #
    # You could add fields manually.
    #

    # add city field to envelope
    #field = GroupDocs::Signature::Field.get!.detect { |f| f.type == :single_line }
    #field.name = 'City'
    #field.location = { location_x: 0.3, location_y: 0.2, page: 1 }
    #envelope.add_field! field, document, recipient
     
    # add signature field to envelope
    #field = GroupDocs::Signature::Field.get!.detect { |f| f.type == :signature }
    #field.location = { location_x: 0.3, location_y: 0.3, page: 1 }
    #envelope.add_field! field, document, recipient

    # send envelope
    envelope.send!
     
    # construct embedded signature url
    url = "https://apps.groupdocs.com/signature/signembed/#{envelope.id}/#{recipient.id}"
    iframe = "<iframe src='#{url}' frameborder='0' width='720' height='600'></iframe>"
   
    #
    # there we wait for document to be signed
    # assuming it's signed, we can proceed
    #
     
    # wait until envelope status has changed to signed
    #envelope = GroupDocs::Signature::Envelope.get! envelope.id
    #until envelope.status == :completed
    #envelope = GroupDocs::Signature::Envelope.get! envelope.id
    #end
     
    # download signed documents as archive
    #zip = envelope.signed_documents! '.'
     
    # archive envelope
    #envelope.archive!
  rescue Exception => e
    err = e.message
  end

  haml :envelope_sample, :locals => { :client_id => settings.client_id, :private_key => settings.private_key, :err => err, :iframe =>  iframe}
end
