get '/sample10' do
  haml :sample10
end

post '/sample10' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :guid, params[:guid]
  set :email, params[:email]
  begin
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.guid.empty? or settings.email.empty?

    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})
    name = nil
    doc = nil
    files_list.each do |element|
      if element.class.name.split('::').last == 'Folder'
        next
      end
      
      if element.guid == settings.guid
        name = element.name 
        doc = element
      end
    end

    shared = doc.to_document.sharers_set!(settings.email.split(" "), { :client_id => settings.client_id, :private_key => settings.private_key});
	if shared
	  shared_emails = settings.email
	end
  rescue Exception => e
    err = e.message
  end  

  haml :sample10, :locals => { :client_id => settings.client_id, :private_key => settings.private_key, :guid => settings.guid, :email=>settings.email, :shared => shared_emails, :err => err }
end
