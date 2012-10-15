describe VLC::Client::MediaControls do
  let(:vlc) { VLC::Client.new(:auto_start => false) }
  after(:each) { vlc.disconnect }

  context 'plays media' do
    it 'from filesystem' do
      mock_tcp_server.should_receive(:puts).once.with('play ./media.mp3')
      vlc.connect

      vlc.play('./media.mp3')
    end

    it 'from a file descriptor' do
      File.stub(:open).and_return {
        f = File.new('./LICENSE', 'r')
        f.should_receive(:path).once.and_return('./media.mp3')
        f
      }

      mock_tcp_server.should_receive(:puts).once.with('play ./media.mp3')
      vlc.connect

      vlc.play(File.open("./media.mp3"))
    end

    it 'from web' do
      mock_tcp_server.should_receive(:puts).once.with('play http://example.org/media.mp3')
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

      tcp.should_receive(:flush).with(no_args).any_number_of_times
      tcp.should_receive(:gets).with(no_args).twice.and_return("")

      tcp.should_receive(:puts).once.with('play http://example.org/media.mp3')

      tcp.should_receive(:puts).once.with("stop")

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

      vlc.connect
      vlc.play('http://example.org/media.mp3')

      vlc.stop
      vlc.should be_stopped

      vlc.play #play current item
      vlc.should be_playing
    end
  end

  it 'is current status aware' do
    tcp = mock_tcp_server(:defaults => false)
    tcp.should_receive(:flush).with(no_args).any_number_of_times

    tcp.should_receive(:gets).with(no_args).twice.and_return("")

    tcp.should_receive(:puts).once.with('is_playing')
    tcp.should_receive(:gets).once.with(no_args).and_return("> > 0")

    tcp.should_receive(:puts).once.with('play http://example.org/media.mp3')

    tcp.should_receive(:puts).once.with('is_playing')
    tcp.should_receive(:gets).once.with(no_args).and_return("> > 1")

    tcp.should_receive(:close).with(no_args)

    vlc.connect

    vlc.should be_stopped
    vlc.play('http://example.org/media.mp3')
    vlc.should be_playing
  end
end