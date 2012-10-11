describe VLC::Connection do
  #TODO: Stub
  before(:all) do
    @server = VLC::Server.new('localhost', 9595, true)
    @server.start
    sleep(1)
  end

  after(:all) { @server.stop }

  context 'when disconnected' do
    let(:connection) { VLC::Connection.new('localhost', 9595) }
    after(:each) { connection.disconnect }

    it 'connects to VLC server' do
      connection.connect
      connection.should be_connected
    end
  end

  context 'when connected' do
    let!(:connection) { VLC::Connection.new('localhost', 9595) }
    before(:each) { connection.connect }

    it 'disconnected from a VLC server' do
      connection.disconnect
      connection.should_not be_connected
    end
  end
end