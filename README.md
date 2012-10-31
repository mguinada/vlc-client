# vlc-client [![Build Status](https://secure.travis-ci.org/mguinada/vlc-client.png?branch=master)](http://travis-ci.org/mguinada/vlc-client)

vlc-client manages a [VLC media player](http://www.videolan.org/vlc/) through it's RC interface.

## Installation

Add this line to your application's Gemfile:

    gem 'vlc-client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vlc-client --pre

## Usage

### Create a client and connect to a running VLC media player instance.

```ruby

#Expects a VLC media player running on 192.168.1.10:9999
#e.g. vlc --extraintf rc --rc-host 192.168.1.10:9999"

vlc = VLC::Client.new('192.168.1.10', 9999)
# => "#<VLC::Client:0x0000000229c370 @server=#<VLC::Server:0x0000000229c6e0 @headless=false, @port=9999, @host=\"192.168.1.10\", @pid=10514>, @self_managed=true, @connection=#<VLC::Connection:0x0000000229c258 @port=9999, @host=\"192.168.1.10\", @socket=#<TCPSocket:fd 5>>>"

vlc.connect
# => true
vlc.play('http://example.org/media.mp3') #play media
# => true
vlc.playing?
# => true
vlc.fullscreen
# => true
#...

```

### Create a self managed client/server system.
_Most of the time we want a local client/server VLC media player system_

_(NOTE: requires a local installation of VLC media player)_

```ruby

vlc = VLC::System.new #A local VLC client/server system where a local VLC server is automaticaly managed
# => "#<VLC::System:0x00000001bbb1a0 @client=#<VLC::Client:0x00000001bbade0 @server=#<VLC::Server:0x00000001bbb178 @headless=false, @port=9595, @host=\"localhost\", @pid=11225>, @connection=#<VLC::Connection:0x00000001bbacc8 @port=9595, @host=\"localhost\", @socket=#<TCPSocket:fd 5>>>>"

vlc.connected? #auto_connect
# => true

vlc.play('http://example.org/media.mp3')
# => true

vlc.progress
# => 1 #%
#...

#Technically this is the same as
vlc = VLC::Client.new(VLC::Server.new('localhost', 9595, false))
# => "#<VLC::Client:0x000000011de128 @server=#<VLC::Server:0x000000011de380 @headless=false, @port=9595, @host=\"localhost\", @pid=12656>, @connection=#<VLC::Connection:0x000000011de038 @port=9595, @host=\"localhost\", @socket=#<TCPSocket:fd 5>>>"
```

###Get local VLC server lifecycle management control
_(NOTE: requires a local installation of VLC media player)_

```ruby

vlc = VLC::System.new('127.0.0.1', 9999, auto_start: false)
# => "#<VLC::System:0x00000001695f68 @client=#<VLC::Client:0x0000000169d718 @server=#<VLC::Server:0x00000001695ec8 @headless=false, @port=9999, @host=\"127.0.0.1\", @pid=VLC::NullObject>, @connection=#<VLC::Connection:0x0000000169d588 @port=9999, @host=\"127.0.0.1\", @socket=VLC::NullObject>>>"

vlc.server.running?
# => false
vlc.server.start
# => 12672
vlc.connect
# => true
```

## Reference

[reference](http://rdoc.info/github/mguinada/vlc-client)

## Support

vlc-client has been tested on linux only.
If you need support for other OS a pull request is welcome.

## Contributing

1. Fork it
2. Create your topic branch (`git checkout -b my-topic-branch`)
3. Add/change specs for your unimplemented feature or bug fix
4. Make sure specs fail by running `bundle exec rake spec`. If not return to step 3
5. Hack it
6. Make sure specs pass (`bundle exec rake spec`). If not return to step 5
7. Edit the documentation so it is coherent with your feature or fix. Run `bundle exec rake yard` to review
8. Commit changes (`git commit -am 'Add some feature/fix'`) and push to the branch (`git push origin my-topic-branch`)
9. Submit a pull request for your branch.

## Copyright

Copyright (c) 2012 Miguel Guinada
[LICENSE][] for details.

[license]: https://github.com/mguinada/vlc-client/blob/master/LICENSE