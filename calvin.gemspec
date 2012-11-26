# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'calvin/version'

Gem::Specification.new do |gem|
  gem.name          = "calvin"
  gem.version       = Calvin::VERSION
  gem.authors       = ["Utkarsh Kukreti"]
  gem.email         = ["utkarshkukreti@gmail.com"]
  gem.description   = %q{Very terse programming language, inspired by APL/J/K.}
  gem.summary       = %q{Very terse programming language, inspired by APL/J/K.}
  gem.homepage      = "https://github.com/utkarshkukreti/calvin"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "docopt"
  gem.add_dependency "parslet"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "pry-nav"
end
