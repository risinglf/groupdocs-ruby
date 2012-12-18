get '/sample7' do
  haml :sample7
end

post '/sample7' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
   
  begin
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?
    files_list = GroupDocs::Storage::Folder.list!('/', {:extended => true}, { :client_id => settings.client_id, :private_key => settings.private_key})

    thumbnails = ''
    files_list.each do |element|
      if element.class.name.split('::').last == 'Folder'
        next
      end
      
      if element.thumbnail
        name = element.name 
        thumbnails += "<p><img src='data:image/png;base64,#{element.thumbnail}', width='40px', height='40px'> #{name}</p>"
      end
    end
    
    unless thumbnails.empty?
      set :thumbnails, thumbnails
    end
  rescue Exception => e
    err = e.message
  end

  haml :sample7, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :thumbnailList => thumbnails, :err => err }
end
