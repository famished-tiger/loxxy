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
      '.yardopts',
      'Gemfile',
      'Rakefile',
      'CHANGELOG.md',
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
  classes, and inheritance. The interpreter passes all unit tests from the original Java implementation.
  It is also able to run `LoxLox` a Lox interpreter written in Lox itself.
  DESCR_END
  spec.homepage      = 'https://github.com/famished-tiger/loxxy'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.1'
  spec.metadata = { 'rubygems_mfa_required' => 'true' }

  spec.bindir        = 'bin'
  spec.executables   = ['loxxy']
  spec.require_paths = ['lib']

  PkgExtending.pkg_files(spec)
  PkgExtending.pkg_documentation(spec)

  # Runtime dependencies
  spec.add_dependency 'rley', '~> 0.9', '>= 0.9.02'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.4', '>= 2.4.1'
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'rspec', '~> 3', '>= 3.10.0'
end
