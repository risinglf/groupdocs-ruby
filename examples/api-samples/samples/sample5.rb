get '/sample5' do
  haml :sample5
end

post '/sample5' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :file_id, params[:file_id]
  set :copy, params[:copy]
  set :move, params[:move]
  set :dest_path, params[:dest_path]
   
  begin
    raise "Please enter all required parameters" if settings.client_id.empty? or settings.private_key.empty? or settings.file_id.empty?

    files_list = GroupDocs::Storage::Folder.list!('/', {}, { :client_id => settings.client_id, :private_key => settings.private_key})
    manipulate_file = nil
    files_list.each do |element|
      if element.id == Integer(settings.file_id)
        manipulate_file = element
      end
    end
    raise "No file with such FileID" if manipulate_file.nil?

    unless settings.copy.nil?
      file = manipulate_file.copy!(settings.dest_path, {}, { :client_id => settings.client_id, :private_key => settings.private_key})
      button = settings.copy
    end

    unless settings.move.nil?
      file = manipulate_file.move!(settings.dest_path, {}, { :client_id => settings.client_id, :private_key => settings.private_key})
      button = settings.move
    end

    if file
      massage = "File was #{button}'ed to the #{settings.dest_path} folder"
    end
 
  rescue Exception => e
    err = e.message
  end  
  
  haml :sample5, :locals => { :userId => settings.client_id, :privateKey => settings.private_key, :file_id => settings.file_id, :dest_path => settings.dest_path, :massage => massage, :err => err }
end
