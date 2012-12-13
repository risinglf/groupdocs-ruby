get '/sample1' do

  haml :sample1
end

post '/sample1' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  begin
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty?
    user = GroupDocs::User.get!({:client_id => settings.client_id, :private_key => settings.private_key})
  rescue Exception => e
    err = e.message
  end
  
  haml :sample1, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :user => user, :err => err }
end
