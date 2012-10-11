# vlc

VLC manages a VLC media player through it's RC interface.

In it's default behaviour it will launch a VLC instance wrapped in a sub process and connect to
it's RC interface. But VLC instance management may be bypassed. This is most usefull when controlling
a remote VLC instance or for fine grained control for the VLC media player lifecycle.

**NOTE**: This project is still in it's inception state

## Installation

Add this line to your application's Gemfile:

    gem 'vlc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vlc

## Usage

### Default behaviour: self managed VLC instance

```ruby

vlc = VLC::Client.new
=> #<VLC::Client:0x00000000c21be0 @host="localhost", @port=9595, @auto_start=true, @headless=true, @process=#<IO:fd 5>, @socket=#<TCPSocket:fd 6>>

vlc.running?
=> true
```

### VLC instance management bypass

```ruby
vlc = VLC::Client.new(auto_start: false)
=> #<VLC::Client:0x00000001a73f90 @auto_start=false, @headless=true, @host="localhost", @port=9595>

vlc.running?
=> false
```

## Reference

[reference](http://rdoc.info/github/mguinada/vlc)

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

[license]: https://github.com/mguinada/vlc/blob/master/LICENSE
