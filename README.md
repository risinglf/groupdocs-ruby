## GroupDocs [![Build Status](https://secure.travis-ci.org/groupdocs/groupdocs-ruby.png)](http://travis-ci.org/groupdocs/groupdocs-ruby)

Ruby SDK for [GroupDocs](http://groupdocs.com) REST API.

## Installation

GroupDocs requires Ruby 1.9. Ruby 1.8 is not supported!

Install as usually

    gem install groupdocs

Installing from source

    gem install bundler # unless it's already installed
    git clone git@github.com:groupdocs/groupdocs-ruby.git
    cd groupdocs-ruby/
    git checkout master
    bundle install --path vendor/bundle
    bundle exec rake install

## Usage

All "bang" methods (ending with exclamation sign) imply interaction with API server.

Other methods (with expect to some methods - see documentation) do not operate with API Server

### Configuration

First of all you need to configure your access to API server.

```ruby
require 'groupdocs'

GroupDocs.configure do |groupdocs|
  groupdocs.client_id = 'your_client_id'
  groupdocs.private_key = 'your_private_key'
  # optionally specify API server and version
  groupdocs.api_server = 'https://dev-api.groupdocs.com'
  groupdocs.api_version = '2.0'
end

GroupDocs::Storage::Folder.create!('/folder')
#=> #<GroupDocs::Storage::Folder:0x0000000171f432 @id=1, @name="folder", @url="http://groupdocs.com">
```

You can also pass access credentials to particular requests

```ruby
GroupDocs::Storage::Folder.create!('/folder', client_id: 'your_client_id', private_key: 'your_private_key')
#=> #<GroupDocs::Storage::Folder:0x0000000171f432 @id=1, @name="folder", @url="http://groupdocs.com">

GroupDocs::Document.find!(:name, 'CV.doc', client_id: 'your_client_id', private_key: 'your_private_key')
#=> #<GroupDocs::Storage::Folder:0x0000000171f432 @id=1, @name="Folder1", @url="http://groupdocs.com">
```

### Entities

All entities can be initialized in several ways.

* Object is created, attributes are set later.

```ruby
folder = GroupDocs::Storage::Folder.new
folder.name = 'Folder'
folder.inspect
#=> #<GroupDocs::Storage::Folder:0x0000000171f432 @name="Folder">
```

* Hash of attributes are passed to object constructor.

```ruby
GroupDocs::Storage::Folder.new(name: 'Folder')
#=> #<GroupDocs::Storage::Folder:0x0000000171f432 @name="Folder">
```

* Block is passed to object constructor.

```ruby
GroupDocs::Storage::Folder.new do |folder|
  folder.name = 'Folder'
end
#=> #<GroupDocs::Storage::Folder:0x0000000171f432 @name="Folder">
```

### Annotation API

Read more about examples of using Annotation API on [wiki](https://github.com/p0deje/groupdocs-ruby/wiki/Annotation-API).

### Assembly API

Read more about examples of using Assembly API on [wiki](https://github.com/p0deje/groupdocs-ruby/wiki/Assembly-API).

### Comparison API

Read more about examples of using Comparison API on [wiki](https://github.com/p0deje/groupdocs-ruby/wiki/Comparison-API).

### Document API

Read more about examples of using Document API on [wiki](https://github.com/p0deje/groupdocs-ruby/wiki/Document-API).

### Job API

Read more about examples of using Job API on [wiki](https://github.com/p0deje/groupdocs-ruby/wiki/Job-API).

### Signature API

Not yet implemented.

### Storage API

Read more about examples of using Storage API on [wiki](https://github.com/p0deje/groupdocs-ruby/wiki/Storage-API).

### Copyright

Copyright (c) 2012 Aspose Inc.
