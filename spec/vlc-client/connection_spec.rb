describe VLC::Connection do
  context 'when disconnected' do
    before(:each)    { mock_tcp_server }
    after(:each)     { connection.disconnect }
    let(:connection) { VLC::Connection.new('localhost', 9595) }

    it 'connects to VLC server' do
      connection.connect
      connection.should be_connected
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

    it 'writes to server' do
      mock_tcp_server do |tcp|
        tcp.should_receive(:puts).once.with('some data')
      end

      connection.connect
      connection.write('some data')
    end
  end
end