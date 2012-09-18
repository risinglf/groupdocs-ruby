require 'sinatra'
require 'groupdocs'
require 'haml'

GroupDocs.api_version = '2.0'

get '/' do
  haml :upload
end

post '/upload' do
  set :client_id, params[:client_id]
  set :private_key, params[:private_key]
  filepath = "#{Dir.tmpdir}/#{params[:file][:filename]}"
  File.open(filepath, 'w') { |f| f.write(params[:file][:tempfile].read) }
  @@file = GroupDocs::Storage::File.upload!(filepath, '/', client_id: options.client_id, private_key: options.private_key)

  haml :annotations
end

get '/annotations' do
  annotations = @@file.to_document.annotations!(client_id: options.client_id, private_key: options.private_key)
  annotations.map { |annotation| annotation.type }.join ", "
end


__END__

@@layout
%html
  %head
    %title GroupDocs Ruby SDK Annotations Sample App
    %script{ src: "http://rightjs.org/hotlink/right.js" }
    :javascript
      "#annotations".onClick(function(event) {
        event.stop();
        $('annotations_list').load("/annotations");
      });
  %body
    = yield


@@upload
%h4 Upload file
%form{ action: '/upload', method: 'post', enctype: 'multipart/form-data' }
  %label{ for: 'client_id' } GroupDocs Client ID
  %br
  %input{ type: 'text', name: 'client_id' }
  %br
  %label{ for: 'private_key' } GroupDocs Private Key
  %br
  %input{ type: 'text', name: 'private_key' }
  %br
  %label{ for: 'file' } File
  %br
  %input{ type: 'file', name: 'file' }
  %br
  %br
  %input{ type: 'submit', value: 'Upload' }

@@annotations
%iframe{ src: "https://apps.groupdocs.com/document-annotation/Embed/#{@@file.guid}", frameborder: 0, width: 600, height: 400 }
%br
%br
%button#annotations Poll annotations
%br
%br
#annotations_list
