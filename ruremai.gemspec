# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ruremai/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['hibariya']
  gem.email         = ['celluloid.key@gmail.com']
  gem.description   = %q{Object.method(:name).rurema!}
  gem.summary       = %q{Open ruby reference manual by browser.}
  gem.homepage      = 'https://github.com/hibariya/ruremai'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'ruremai'
  gem.require_paths = ['lib']
  gem.version       = Ruremai::VERSION

  gem.add_runtime_dependency 'launchy', '~> 2.4.3'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'tapp', '~> 1.5.0'
  gem.add_development_dependency 'rspec', '~> 3.2.0'
end
