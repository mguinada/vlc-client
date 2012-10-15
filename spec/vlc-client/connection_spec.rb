describe VLC::Connection do
  context 'when disconnected' do
    after(:each)     { connection.disconnect }
    let(:connection) { VLC::Connection.new('localhost', 9595) }

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
    after(:each) { connection.close }
    let(:connection) { VLC::Connection.new('localhost', 9595) }

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

    it 'raises error on unreadable content' do
      mock_tcp_server
      connection.should_receive(:process_data).once.and_return(nil)

      expect { connection.write('some data', false) }.to raise_error(VLC::ProtocolError)
    end
  end
end