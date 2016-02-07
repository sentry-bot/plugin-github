# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "sentry-github"
  gem.version       = File.new("VERSION", 'r').read.chomp
  gem.summary       = %q{Fetches information about posted GitHub links}
  gem.license       = "MIT"
  gem.authors       = ["Alexander Persson"]
  gem.email         = "apersson.93@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/sentry-github"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'

  gem.add_dependency "cinch", "~> 2.0"
  gem.add_dependency "octokit", "~> 4.0"
  gem.add_dependency "actionpack", "~> 4.2"
  gem.add_dependency "twitter-text", "~> 1.13"
  gem.add_dependency "sentry-helper", "~> 0.1.0"
end
