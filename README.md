# vlc-client [![Build Status](https://secure.travis-ci.org/mguinada/vlc-client.png?branch=master)](http://travis-ci.org/mguinada/vlc-client)

vlc-client manages a [VLC media player](http://www.videolan.org/vlc/) instance through it's RC interface.

### Installation

Add this line to your application's Gemfile:

    gem 'vlc-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vlc-client

### Usage

##### Create a client and connect to a running VLC media player instance.

```ruby

#Expects a VLC media player running on `192.168.1.10:9999`, e.g. `vlc --extraintf rc --rc-host 192.168.1.10:9999`
vlc = VLC::Client.new('192.168.1.10', 9999)

vlc.connect # connect to server
# => true

vlc.play('http://example.org/media.mp3') # play media
# => true

vlc.playing?
# => true

vlc.fullscreen
# => true
#...

```

##### Create a self managed client/server system.
Most of the time we want a local client/server VLC media player system


```ruby

# A client/server system where a local VLC installation is automaticaly managed
vlc = VLC::System.new

vlc.connected? # auto connect
# => true

vlc.play('http://example.org/media.mp3')
# => true

vlc.progress
# => 1 #%
#...

#Technically this is the same as
vlc = VLC::Client.new(VLC::Server.new('localhost', 9595, false))
```

##### Get local VLC server lifecycle management control

```ruby
vlc = VLC::System.new('127.0.0.1', 9999, auto_start: false)

vlc.server.running?
# => false

vlc.server.start
# => 12672

vlc.connect
# => true
```

### Reference

[reference](http://rdoc.info/github/mguinada/vlc-client)

### Notice

vlc-client has been tested on linux but it should work on any VLC installation as long as the command line is responsive for `vlc` and `cvlc` calls. On Mac OS X these are not available by default. They can be created with:

```
echo "alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'" >> ~/.bash_profile
echo "alias cvlc='/Applications/VLC.app/Contents/MacOS/VLC'" >> ~/.bash_profile
```

### Contributing

1. Fork it
2. Create your topic branch (`git checkout -b my-topic-branch`)
3. Add/change specs for your unimplemented feature or bug fix
4. Hack it
5. Make sure specs pass (`bundle exec rake spec`)
6. Edit the documentation so it is coherent with your feature or fix. Run `bundle exec rake yard` to review
7. Commit changes (`git commit -am 'Add some feature/fix'`) and push to the branch (`git push origin my-topic-branch`)
8. Submit a pull request

### Copyright

Copyright (c) 2012 Miguel Guinada
[LICENSE][] for details.

[license]: https://github.com/mguinada/vlc-client/blob/master/LICENSE