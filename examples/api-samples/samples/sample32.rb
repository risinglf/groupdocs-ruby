# GET request
get '/sample32' do
  haml :sample32
end

# POST request
post '/sample32/callback' do

  source_id = ''
  client_id = ''
  private_key = ''
  subscriber_email = ''

  # Get callback request
  data = JSON.parse(request.body.read)
  begin
    raise 'Empty params!' if data.empty?

    # Get value of SourceId
    data.each do |key, value|
      if key == 'SourceId'
        source_id = value
      end
    end

    # Get private key and client_id from file user_info.txt
    if File.exist?("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = File.read("#{File.dirname(__FILE__)}/../public/user_info.txt")
      contents = contents.split(' ')
      client_id = contents[0]
      private_key = contents[1]
      subscriber_email = contens[2]
    end

    # Create new Form
    form = GroupDocs::Signature::Form.new({:id => source_id})

    # Get document by Form id
    document = form.documents!({}, {:client_id => client_id, :private_key => private_key})

    # An adress recipient
    to = subscriber_email

    # The Body message
    body = "
          <html>
            <head>
              <title>Sign form notification</title>
            </head>
            <body>
              <p>Document #{document.name} is signed</p>
            </body>
          </html>"


    # A method send the mail
    def send_mail(to, body)
      #implement your send mail function with your SMTP server
       return true
    end

    send_mail(to, body)  #send notification mail

  rescue Exception => e
    err = e.message
  end
end


# GET request
get '/sample32/check' do

  # Check is there download directory
  unless File.directory?("#{File.dirname(__FILE__)}/../public/downloads")
    return 'Directory was not found.'
  end

  # Get file name from download directory
  name = nil
  Dir.entries("#{File.dirname(__FILE__)}/../public/downloads").each do |file|
    name = file if file != '.' && file != '..'
  end

  name
end



# POST request
post '/sample32' do
  # set variables
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  set :template_guid, params[:template]
  set :form_guid, params[:form]
  set :email, params[:email]
  set :callback, params[:callback]
  set :source, params[:source]

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
    raise 'Please enter all required parameters' if settings.client_id.empty? or settings.private_key.empty?

    # Configure your access to API server.
    GroupDocs.configure do |groupdocs|
      groupdocs.client_id = settings.client_id
      groupdocs.private_key = settings.private_key
    end

    # Write client and private key to the file for callback job
    if settings.callback[0]
      out_file = File.new("#{File.dirname(__FILE__)}/../public/user_info.txt", 'w')
      # white space is required
      out_file.write("#{settings.client_id} ")
      out_file.write("#{settings.private_key}")
      out_file.write("#{settings.email}")
      out_file.close
    end

    iframe = ''

    case settings.source
    when 'form'
      # Create new Form with guid
      form = GroupDocs::Signature::Form.new({:guid => settings.form_guid})

      # Publish the Form
      form.publish!({:callbackUrl => settings.callback})

      iframe = "https://apps.groupdocs.com/signature2/forms/signembed/ #{settings.form_guid}";
    when 'template'

      form = GroupDocs::Signature::Form.new
      form.name = 'test'
      form.notifyOwnerOnSign = true


      # Create new Form with template
      signature = form.create!({ :templateId => settings.template_guid})

      # Publish the Form
      form.publish!({:callbackUrl => settings.callback})

      iframe = "<iframe width='100%' height='600' frameborder='0' src='https://apps.groupdocs.com/signature2/forms/signembed/ #{signature}'></iframe>"
    end

  rescue Exception => e
    err = e.message
  end

  # Set variables for template
  haml :sample32, :locals => {:userId => settings.client_id,
                              :privateKey => settings.private_key,
                              :callback => settings.callback,
                              :email => settings.email,
                              :iframe => iframe,
                              :err => err}
end
