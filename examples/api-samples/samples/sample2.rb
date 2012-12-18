get '/sample2' do
  haml :sample2
end

post '/sample2' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]

  begin
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?
    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})
    filelist = ''
    files_list.each {|element| filelist += element.name + '<br />'}
  rescue Exception => e
    err = e.message
  end  
  
  haml :sample2, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :filelist => filelist, :err => err }
end
