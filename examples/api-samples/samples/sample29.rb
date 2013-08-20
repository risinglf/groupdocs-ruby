get '/sample29' do
  haml :sample29
end

# POST request
post '/sample29' do

  # set variables
  set :client_id, params[:clientId]
  set :base_path, params[:basePath]
  set :url, params[:url]

  url = settings.url
  base_path = settings.base_path
  client_id = settings.client_id

  begin

    #If base base is empty seting base path to prod server
    base_path = 'https://api.groupdocs.com/v2.0' unless !base_path.empty?

    #Generate iframe url for chosen server
    if (!url.empty?)

       if (base_path == "https://api.groupdocs.com/v2.0")
         iframe = "https://apps.groupdocs.com/document-viewer/embed?url=#{url} + '&user_id=#{client_id}"
       elsif (base_path == "https://dev-api.groupdocs.com/v2.0")

        #iframe to dev server
         iframe = "https://dev-apps.groupdocs.com/document-viewer/embed?url=#{url} + '&user_id=#{client_id}"
       elsif (base_path == "https://stage-api.groupdocs.com/v2.0")

         #iframe to test server
         iframe = "https://stage-apps.groupdocs.com/document-viewer/embed?url=#{url} + '&user_id=#{client_id}"
       elsif (base_path == "http://realtime-api.groupdocs.com")
         iframe = "http://realtime-apps.groupdocs.com/document-viewer/embed?url=#{url} + '&user_id=#{client_id}"
       end


    end

  rescue Exception => e
    err = e.message
  end

  require 'json'
  content_type 'text/html'

  #Create json string with result data
  iframe = {:iframe => iframe, :error => ''}.to_json

end