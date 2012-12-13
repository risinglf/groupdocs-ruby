get '/sample3' do

  haml :sample3
end

post '/sample3' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  begin
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?
    
    filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
    File.open(filepath, 'wb') { |f| f.write(params[:file][:tempfile].read) }
    file = GroupDocs::Storage::File.upload!(filepath, {}, client_id: settings.client_id, private_key: settings.private_key)
    massage = "<p>File was uploaded to GroupDocs. Here you can see your <strong>#{params[:file][:filename]}</strong> file in the GroupDocs Embedded Viewer.</p>"
    iframe = "<iframe src='https://apps.groupdocs.com/document-viewer/Embed/#{file.guid}' frameborder='0' width='720' height='600'></iframe>"
  
  rescue Exception => e
    err = e.message
  end  
  
  haml :sample3, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :iframe=>iframe, :massage => massage, :err => err }
end
