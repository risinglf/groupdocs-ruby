## GroupDocs [![Build Status](https://secure.travis-ci.org/p0deje/groupdocs-ruby.png)](http://travis-ci.org/p0deje/groupdocs-ruby)

GroupDocs gem implements API wrapper for http://groupdocs.com

## Installation

GroupDocs requires at least Ruby 1.9.2. Ruby 1.8.7 is not supported!

Install as usually

    gem install groupdocs

If you want to try latest version of gem (or it's not yet published)

    gem install bundler # unless it's already installed
    git clone git@github.com:p0deje/groupdocs-ruby.git
    cd groupdocs-ruby/
    git checkout master
    bundle install --path vendor/bundle
    bundle exec rake install

## Usage

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
```

### Entities

All entities can be initialized in several ways.

* Object is created, attributes are set later.

```ruby
folder = GroupDocs::Storage::Folder.new
folder.name = 'Folder'
folder.inspect
#=> <#GroupDocs::Storage::Folder @id=nil @name="Folder" @url="">
```

* Hash of attributes are passed to object constructor.

```ruby
GroupDocs::Storage::Folder.new(name: 'Folder')
#=> <#GroupDocs::Storage::Folder @id=nil @name="Folder" @url="">
```

* Block is passed to object constructor.

```ruby
GroupDocs::Storage::Folder.new do |folder|
  folder.name = 'Folder'
end
#=> <#GroupDocs::Storage::Folder @id=nil @name="Folder" @url="">
```

Note, that all "bang" methods (ending with exclamation sign) means interaction with API server.

### Find entities

Some entities support `#all!, `#find!` and `#find_all!` methods. You can pass any attribute that object responds to and its value to find with.

* List all files

```ruby
GroupDocs::Storage::File.all!
#=> [<#GroupDocs::Storage::File @id=123 @guid=uhfsa9dry29rhfodn @name="resume.pdf" @url="http://groupdocs.com">, <#GroupDocs::Storage::File @id=456 @guid=soif97sr9u24bfosd9 @name="CV.doc" @url="http://groupdocs.com">]
```

* Find folder with name `Folder1`

```ruby
GroupDocs::Storage::Folder.find!(:name, 'Folder1')
#=> <#GroupDocs::Storage::Folder @id=1 @name="Folder1" @url="http://groupdocs.com">
```

* Find all folders which name starts with `Folder`

```ruby
GroupDocs::Storage::Folder.find_all!(:name, /^Folder/)
#=> [<#GroupDocs::Storage::Folder @id=1 @name="Folder1" @url="http://groupdocs.com">, <#GroupDocs::Storage::Folder @id=2 @name="Folder2" @url="http://groupdocs.com">]
```

### Storage API

Read more about examples of using Storage API on [wiki](https://github.com/p0deje/groupdocs-ruby/wiki/Storage-API).

### Copyright

Copyright (c) 2012 Aspose Inc.
