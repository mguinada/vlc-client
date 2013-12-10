# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vlc-client/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Miguel Guinada"]
  gem.email         = ["mguinada@gmail.com"]
  gem.description   = %q{vlc-client allows to control VLC media player over TCP}
  gem.summary       = %q{vlc-client is a TCP client for VLC media player}
  gem.homepage      = "https://github.com/mguinada/vlc-client"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vlc-client"
  gem.require_paths = ["lib"]
  gem.version       = VLC::VERSION
  gem.date          = Time.now.utc.strftime("%Y-%m-%d")

  gem.add_dependency 'retryable', '~> 1.3'
end
