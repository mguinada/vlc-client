describe VLC::Client::MediaControls do
  after(:each) { vlc.disconnect }
  let(:vlc)    { VLC::Client.new(:self_managed => false) }

  context 'plays media' do
    it 'from filesystem' do
      mock_tcp_server.should_receive(:puts).once.with('add ./media.mp3')
      vlc.connect

      vlc.play('./media.mp3')
    end

    it 'from a file descriptor' do
      mock_file('./media.mp3')

      mock_tcp_server.should_receive(:puts).once.with('add ./media.mp3')
      vlc.connect

      vlc.play(File.open("./media.mp3"))
    end

    it 'from web' do
      mock_tcp_server.should_receive(:puts).once.with('add http://example.org/media.mp3')
      vlc.connect

      vlc.play('http://example.org/media.mp3')
    end

    it 'raises error for unknown schemas' do
      mock_tcp_server
      vlc.connect

      expect { vlc.play(Class.new) }.to raise_error(ArgumentError)
    end
  end

  context 'when playing media' do
    def tcp_mock
      tcp = mock_tcp_server(:defaults => false)

      tcp.should_receive(:flush).with(no_args).at_least(1).times
      tcp.should_receive(:gets).with(no_args).twice.and_return("")

      tcp.should_receive(:puts).once.with('add http://example.org/media.mp3')

      tcp.should_receive(:close).with(no_args)
      tcp
    end

    it 'may stop playback' do
      tcp = tcp_mock
      tcp.should_receive(:puts).once.with('is_playing')
      tcp.should_receive(:gets).once.with(no_args).and_return("0")

      tcp.should_receive(:puts).once.with('play')
      tcp.should_receive(:puts).once.with('is_playing')
      tcp.should_receive(:gets).once.with(no_args).and_return("1")

      tcp.should_receive(:puts).once.with("stop")

      vlc.connect
      vlc.play('http://example.org/media.mp3')

      vlc.stop
      vlc.should be_stopped

      vlc.play #play current item
      vlc.should be_playing
    end

    it 'may pause playback' do
      tcp = tcp_mock

      tcp.should_receive(:puts).once.with('pause')
      tcp.should_receive(:puts).once.with('is_playing')
      tcp.should_receive(:gets).once.with(no_args).and_return("0")


      vlc.connect
      vlc.play('http://example.org/media.mp3')

      vlc.pause
      vlc.should be_stopped
    end

    it 'may resume playback' do
      tcp = tcp_mock

      tcp.should_receive(:puts).once.with('pause')
      tcp.should_receive(:puts).once.with('play')
      tcp.should_receive(:puts).once.with('is_playing')
      tcp.should_receive(:gets).once.with(no_args).and_return('1')

      vlc.connect
      vlc.play('http://example.org/media.mp3')

      vlc.pause
      vlc.play
      vlc.should be_playing
    end

    it 'displays the playing media title' do
      tcp = tcp_mock
      tcp.should_receive(:puts).once.with('get_title')
      tcp.should_receive(:gets).once.and_return('test media')
      tcp.should_receive(:puts).once.with('stop')
      tcp.should_receive(:puts).once.with('get_title')
      tcp.should_receive(:gets).once.and_return('')

      vlc.connect
      vlc.play('http://example.org/media.mp3')

      vlc.title.should eq('test media')
      vlc.stop

      vlc.title.should be_empty
    end

    it 'reads the volume level' do
      tcp = tcp_mock

      tcp.should_receive(:puts).once.with('volume')
      tcp.should_receive(:gets).once.and_return('100')

      vlc.connect
      vlc.play('http://example.org/media.mp3')
      vlc.volume.should eq(100)
    end

    it 'sets the volume level' do
      tcp = tcp_mock

      tcp.should_receive(:puts).once.with('volume 150')
      tcp.should_receive(:puts).once.with('volume')
      tcp.should_receive(:gets).once.and_return('150')

      vlc.connect
      vlc.play('http://example.org/media.mp3')
      vlc.volume = 150

      vlc.volume.should eq(150)
    end

    it 'is aware of track time' do
      tcp = tcp_mock

      tcp.should_receive(:puts).once.with('get_time')
      tcp.should_receive(:gets).once.and_return('60')

      vlc.connect
      vlc.play('http://example.org/media.mp3')

      vlc.time.should eq(60)
    end

    it 'is aware of track length' do
      tcp = tcp_mock

      tcp.should_receive(:puts).once.with('get_length')
      tcp.should_receive(:gets).once.and_return('100')

      vlc.connect
      vlc.play('http://example.org/media.mp3')

      vlc.length.should eq(100)
    end

    it 'is aware of track progress' do
      vlc.stub(:length).and_return { 0 }
      vlc.stub(:time).and_return { 100 }
      vlc.progress.should eq(0)

      vlc.stub(:length).and_return { 100 }
      vlc.stub(:time).and_return { 0 }
      vlc.progress.should eq(0)

      vlc.stub(:length).and_return { 100 }
      vlc.stub(:time).and_return { 10 }
      vlc.progress.should eq(10)

      vlc.stub(:length).and_return { 100 }
      vlc.stub(:time).and_return { 100 }
      vlc.progress.should eq(100)
    end
  end

  it 'is aware of current status' do
    tcp = mock_tcp_server(:defaults => false)
    tcp.should_receive(:flush).with(no_args).at_least(1).times

    tcp.should_receive(:gets).with(no_args).twice.and_return("")

    tcp.should_receive(:puts).once.with('is_playing')
    tcp.should_receive(:gets).once.with(no_args).and_return("> > 0")

    tcp.should_receive(:puts).once.with('add http://example.org/media.mp3')

    tcp.should_receive(:puts).once.with('is_playing')
    tcp.should_receive(:gets).once.with(no_args).and_return("> > 1")

    tcp.should_receive(:close).with(no_args)

    vlc.connect

    vlc.should be_stopped
    vlc.play('http://example.org/media.mp3')
    vlc.should be_playing
  end
end