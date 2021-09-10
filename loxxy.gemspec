# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loxxy/version'

# Implementation module
module PkgExtending
  def self.pkg_files(aPackage)
    file_list = Dir[
      '.rubocop.yml',
      '.rspec',
      '.travis.yml',
      '.yardopts',
      'Gemfile',
      'Rakefile',
      'CHANGELOG.md',
      'CODE_OF_CONDUCT.md',
      'LICENSE.txt',
      'README.md',
      'loxxy.gemspec',
      'bin/*.rb',
      'lib/*.*',
      'lib/**/*.rb',
      'spec/**/*.rb'
    ]
    aPackage.files = file_list
    aPackage.test_files = Dir['spec/**/*_spec.rb']
    aPackage.require_path = 'lib'
  end

  def self.pkg_documentation(aPackage)
    aPackage.rdoc_options << '--charset=UTF-8 --exclude="examples|spec"'
    aPackage.extra_rdoc_files = ['README.md']
  end
end # module

Gem::Specification.new do |spec|
  spec.name          = 'loxxy'
  spec.version       = Loxxy::VERSION
  spec.authors       = ['Dimitri Geshef']
  spec.email         = ['famished.tiger@yahoo.com']
  spec.summary       = 'An implementation of the Lox programming language.'
  spec.description   = <<-DESCR_END
  A Ruby implementation of the Lox programming language. Lox is a dynamically typed,
  object-oriented programming language that features first-class functions, closures,
  classes, and inheritance.
  DESCR_END
  spec.homepage      = 'https://github.com/famished-tiger/loxxy'
  spec.license       = 'MIT'
  spec.required_ruby_version = '~> 2.5'

  spec.bindir        = 'bin'
  spec.executables   = ['loxxy']
  spec.require_paths = ['lib']

  PkgExtending.pkg_files(spec)
  PkgExtending.pkg_documentation(spec)

  # Runtime dependencies
  spec.add_dependency 'rley', '~> 0.8.03'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
