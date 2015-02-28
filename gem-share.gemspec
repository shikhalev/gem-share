# encoding: utf-8

require 'set_version'
require_relative 'lib/gem-share'

Gem::Specification.new do |g|

  g.name = File.basename __FILE__, ".gemspec"
  g.summary = 'Manage search paths provided by some gems'
  g.author = 'Ivan Shikhalev'
  g.email = 'shikhalev@gmail.com'
  g.homepage = 'https://github.com/shikhalev/gem-share'
  g.description = g.summary + '.'
  g.license = 'GNU LGPLv3'

  g.files = [ 'lib/gem-share.rb', 'README.md', 'LICENSE' ]

  g.set_version(*Share::VERSION, git: true)

  g.require_path = 'lib'

  g.required_ruby_version = '~> 2.0'
  g.add_development_dependency 'set_version', '~> 0.1'

end


