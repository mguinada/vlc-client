# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vlc/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Miguel Guinada"]
  gem.email         = ["mguinada@gmail.com"]
  gem.description   = %q{vlc allows to control VLC media player over TCP }
  gem.summary       = %q{vlc is a TCP client for VLC media player}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vlc"
  gem.require_paths = ["lib"]
  gem.version       = VLC::VERSION
end
