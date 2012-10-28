describe VLC::Connection do
  after(:each)     { connection.disconnect }
  let(:connection) { VLC::Connection.new('localhost', 9595) }

  context 'when disconnected' do
    it 'connects to VLC server' do
      mock_tcp_server

      connection.connect
      connection.should be_connected
    end

    it 'connection failure raises error' do
      TCPSocket.should_receive(:new).and_raise(Errno::ECONNREFUSED)
      expect { connection.connect }.to raise_error(VLC::ConnectionRefused)
    end
  end

  context 'when connected' do
    it 'disconnects from a VLC server' do
      mock_tcp_server
      connection.connect

      connection.disconnect
      connection.should_not be_connected
    end

    it 'writes data to server' do
      mock_tcp_server.should_receive(:puts).once.with('some data')

      connection.connect
      connection.write('some data')
    end

    it 'reads data from server' do
      tcp = mock_tcp_server
      tcp.should_receive(:puts).once.with('some data')
      tcp.should_receive(:gets).once.and_return('some response data')

      connection.connect
      connection.write('some data', false)
    end
  end

  context 'raises error on' do
    it 'unreadable content' do
      tcp = mock_tcp_server
      tcp.should_receive(:puts).once.with('some data')
      tcp.should_receive(:gets).once.and_return('some response data')

      connection.connect
      connection.should_receive(:process_data).once.and_return(nil)

      expect { connection.write('some data', false) }.to raise_error(VLC::ProtocolError)
    end

    it 'broken pipe' do
      mock_tcp_server.should_receive(:puts).with('something').and_raise(Errno::EPIPE)

      connection.connect
      expect { connection.write('something') }.to raise_error(VLC::BrokenConnectionError)
      connection.should_not be_connected
    end

    it 'write on a disconnected connection' do
      connection.stub(:connected?).and_return(false)
      expect { connection.write('something') }.to raise_error(VLC::NotConnectedError)
    end
  end
end
