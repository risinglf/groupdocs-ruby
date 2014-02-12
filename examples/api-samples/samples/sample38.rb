# GET request
get '/sample38' do
  haml :sample38
end




# POST request
post '/sample38' do
  # Set variables
  set :client_id, params[:clientId]
  set :private_key, params[:privateKey]
  set :email, params[:email]
  set :source, params[:source]
  set :file_id, params[:fileId]
  set :url, params[:url]
  set :first_name, params[:firstName]
  set :last_name, params[:lastName]
  set :base_path, params[:basePath]
  #raise params.to_yaml
  # Set download path
  downloads_path = "#{File.dirname(__FILE__)}/../public/downloads"

  # Remove all files from download directory or create folder if it not there
  if File.directory?(downloads_path)
    Dir.foreach(downloads_path) { |f| fn = File.join(downloads_path, f); File.delete(fn) if f != '.' && f != '..' }
  else
    Dir::mkdir(downloads_path)
  end


  begin
    # Check required variables
    #raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty? or settings.email.empty? or settings.first_name.empty? or settings.last_name?

    if settings.base_path.empty? then settings.base_path = 'https://api.groupdocs.com' end

    # Configure your access to API server
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
      # Optionally specify API server and version
      groupdocs.api_server = settings.base_path # default is 'https://api.groupdocs.com'
    end

    # Get document by file GUID
    case settings.source
      when 'guid'
        # Create instance of File
        file = GroupDocs::Storage::File.new({:guid => settings.file_id})
      when 'local'
        # Construct path
        file_path = "#{Dir.tmpdir}/#{params[:file][:filename]}"
        # Open file
        File.open(file_path, 'wb') { |f| f.write(params[:file][:tempfile].read) }
        # Make a request to API using client_id and private_key
        file = GroupDocs::Storage::File.upload!(file_path, {})
      when 'url'
        # Upload file from defined url
        file = GroupDocs::Storage::File.upload_web!(settings.url)
      else
        raise 'Wrong GUID source.'
    end

    #Get all users from accaunt
    user = GroupDocs::User.get!
    userGuid = nil
    users = user.users!
    users.map do |user|
      email = user.primary_email
      # Check whether there is a user with entered email
      if settings.email == email
        # Get user GUID
        userGuid = user.guid
        break
      end
    end
    # Check is user with entered email was founded in GroupDocs account, if not user will be created
    if userGuid.nil?
      userNew = GroupDocs::User.new
      # Set email as entered email
      userNew.primary_email = settings.email
      # Set nick name as entered first name
      userNew.nickname = settings.first_name
      # Set first name as entered first name
      userNew.firstname = settings.first_name
      # Set last name as entered last name
      userNew.lastname = settings.last_name
      # Set roles
      userNew.roles = [{:id => '3', :name => 'User'}]

      # Update account
      new_user = GroupDocs::User.update_account!(userNew)
      guid = new_user.guid
      # Create array with entered email for set_collaborators! method
      emails = [settings.email]
      document = file.to_document
      # Make request to Ant api for set new user as annotation collaborator
      addCollaborator = document.set_collaborators!(emails)
      getCollaborator = document.collaborators!
      getCollaborator.each do |reviewer|
        reviewer.access_rights = %w(view)
      end
      setReviewers = document.set_reviewers! reviewers
      if setReviewers
        case settings.base_path
          when 'https://stage-api-groupdocs.dynabic.com'
            iframe = "https://stage-api-groupdocs.dynabic.com/document-annotation2/embed/#{file.guid}?&uid=#{guid}&download=true"
          when 'https://dev-api-groupdocs.dynabic.com'
            iframe = "https://dev-apps.groupdocs.com//document-annotation2/embed/#{file.guid}?&uid=#{guid}&download=true"
          else
            iframe = "https://apps.groupdocs.com//document-annotation2/embed/#{file.guid}?&uid=#{guid}&download=true"
        end
        # Construct result string
        url = GroupDocs::Api::Request.new(:path => iframe).prepare_and_sign_url

      end
    end

  rescue Exception => e
    err = e.message
  end

  # set variables for template
  haml :sample38, :locals => {:userId => settings.client_id, :privateKey => settings.private_key, :url => url, :email => settings.email, :firstName => settings.first_name, :lastName => settings.last_name, :err => err}
end
