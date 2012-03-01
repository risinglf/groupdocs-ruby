## GroupDocs [![Build Status](https://secure.travis-ci.org/p0deje/groupdocs-ruby.png)](http://travis-ci.org/p0deje/groupdocs-ruby)

GroupDocs gem implements API wrapper for http://groupdocs.com

## Installation

Install as usually

    gem install groupdocs

If you want to try latest version of gem (or it's not yet published)

    git clone git@github.com:p0deje/groupdocs-ruby.git
    rake gem
    gem install pkg/groupdocs-version.gem

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

All entities support `#find!` and `#find_all!` methods. You can pass any attribute that object responds to and its value to find with.

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

* Create new folder on server.

```ruby
GroupDocs::Storage::Folder.create!('/folder')
#=> <#GroupDocs::Storage::Folder @id=1 @name="folder" @url="http://groupdocs.com">
```

or

```ruby
folder = GroupDocs::Storage::Folder.new(name: 'Folder')
folder.create!
#=> <#GroupDocs::Storage::Folder @id=1 @name="Folder" @url="http://groupdocs.com">
```

* List all folders and files in the root.

```ruby
GroupDocs::Storage::Folder.list!
#=> [<#GroupDocs::Storage::Folder @id=1 @name="Folder1" @url="http://groupdocs.com">, <#GroupDocs::Storage::Folder @id=2 @name="Folder2" @url="http://groupdocs.com">]
```

* List all folders and files in the folder.

```ruby
GroupDocs::Storage::Folder.list!('/Folder1')
#=> [<#GroupDocs::Storage::Folder @id=1 @name="Folder1" @url="http://groupdocs.com">]
```

or

```ruby
folder = GroupDocs::Storage::Folder.find!(:name, 'Folder1')
folder.list!
#=> [<#GroupDocs::Storage::Folder @id=1 @name="Folder1" @url="http://groupdocs.com">]
```

* Move folder contents to new folder.

```ruby
folder = GroupDocs::Storage::Folder.find!(:name, 'Folder1')
folder.move!('/Folder2')
#=> '/Folder2'
```

* Rename folder.

```ruby
folder = GroupDocs::Storage::Folder.find!(:name, 'Folder1')
folder.rename!('Folder2')
#=> 'Folder2'
```

* Copy folder with all contents to a new folder.

```ruby
folder = GroupDocs::Storage::Folder.find!(:name, 'Folder1')
folder.copy!('/Folder2')
#=> '/Folder2'
```

* Delete folder.

```ruby
folder = GroupDocs::Storage::Folder.find!(:name, 'Folder1')
folder.delete!
#=> nil
```
