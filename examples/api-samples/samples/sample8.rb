get '/sample8' do
  haml :sample8
end
post '/sample8' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :guid, params[:guid]
  set :page_number, params[:page_number]
  
  
   #   file = GroupDocs::Storage::Folder.list!.last
   #   document = file.to_document
   #   document.page_images! 1024, 768, first_page: 0, page_count: 1 
   
  begin
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?
    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})
    doc = nil
    metadata = nil
    files_list.each do |element|
      if element.class.name.split('::').last == 'Folder'
        next
      end
      
      if element.guid == settings.guid
        metadata = element.to_document.metadata!({ :client_id => settings.client_id, :private_key => settings.private_key})
        doc = element.to_document
      end
    end
    images =  doc.page_images!(800, 400, {:first_page => 0, :page_count => metadata.page_count}, { :client_id => settings.client_id, :private_key => settings.private_key})

    unless images.empty?
      image = images[Integer(settings.page_number)]
    end
  rescue Exception => e
    err = e.message
  end  
  
  haml :sample8, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :guid =>settings.guid , :page_number=>settings.page_number, :image=>image, :err => err }
end
