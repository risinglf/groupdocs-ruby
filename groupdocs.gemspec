# encoding: utf-8
$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
require "groupdocs/version"

Gem::Specification.new do |s|
  s.name        = 'groupdocs'
  s.version     = GroupDocs::VERSION
  s.authors     = 'Alex Rodionov'
  s.email       = 'p0deje@gmail.com'
  s.homepage    = 'http://groupdocs.com'
  s.summary     = 'GroupDocs API Wrapper'
  s.description = 'GroupDocs API Wrapper'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path = 'lib'

  s.add_runtime_dependency 'rest-client', '~> 1.6'
  s.add_runtime_dependency 'ruby-hmac'  , '~> 0.4'

  s.add_development_dependency 'rspec'    , '~> 2.8'
  s.add_development_dependency 'rake'     , '~> 0.9'
  s.add_development_dependency 'simplecov', '~> 0.6'
  s.add_development_dependency 'yard'     , '~> 0.7'
end
