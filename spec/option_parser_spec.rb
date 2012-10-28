require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include LaunchAgent

describe CLI::OptionParser do
  before do
    @argv = %w/ruby foo.rb/
    @opts = {
      :env => ''
    }
  end

  shared_examples_for 'valid agent' do
    it "should have necessary attributes" do
      agent = CLI::OptionParser.new(opts, @argv).agent
      plist = agent2plist(agent)

      plist['Label'].should eql('com.buycheapviagraonlinenow.ruby__foo_rb')
      plist['ProgramArguments'].should eql(@argv)
    end
  end

  describe 'empty argv' do
    let(:opts) do
      @opts.merge(
        '--daemon' => true)
    end

    it 'should raise if argv is empty' do
      lambda {
        CLI::OptionParser.new(opts, []).agent
      }.should raise_error('full command must be supplied')
    end
  end

  describe 'empty env' do
    let(:opts) do
      @opts.merge(
        '--env' => nil,
        '--daemon' => true)
    end

    it_should_behave_like 'valid agent'
  end

  describe 'empty options' do
    let(:opts) do
      @opts
    end

    it 'should raise if option is empty' do
      lambda {
        CLI::OptionParser.new(opts, @argv).agent
      }.should raise_error('at least one of --daemon and --interval must be set')
    end
  end

  describe 'daemon' do
    let(:opts) do
      @opts.merge(
        '--daemon' => true)
    end

    it_should_behave_like 'valid agent'

    it 'should parse daemon option' do
      agent = CLI::OptionParser.new(opts, @argv).agent
      plist = agent2plist(agent)

      plist['KeepAlive'].should eql({
          'SuccessfulExit' => false
        })
      plist['RunAtLoad'].should be_true
    end
  end

  describe 'wdir' do
    let(:opts) do
      @opts.merge(
        '--daemon' => true,
        '--wdir' => '/foo/bar')
    end

    it_should_behave_like 'valid agent'

    it 'should parse wdir option' do
      agent = CLI::OptionParser.new(opts, @argv).agent
      plist = agent2plist(agent)

      plist['WorkingDirectory'].should eql('/foo/bar')
    end
  end

  describe 'env' do
    let(:opts) do
      @opts.merge(
        '--daemon' => true,
        '--env' => 'FOO=BAR,BAR=BAZ')
    end

    it_should_behave_like 'valid agent'

    it 'should parse env option' do
      agent = CLI::OptionParser.new(opts, @argv).agent
      plist = agent2plist(agent)

      plist['EnvironmentVariables'].should eql({ 'FOO' => 'BAR', 'BAR' => 'BAZ' })
    end
  end

  describe '--stdout' do
    let(:opts) do
      @opts.merge(
        '--daemon' => true,
        '--stdout' => '~/foo/bar.log')
    end

    it_should_behave_like 'valid agent'

    it 'should parse env option' do
      agent = CLI::OptionParser.new(opts, @argv).agent
      plist = agent2plist(agent)

      plist['StandardOutPath'].should eql(File.expand_path('~/foo/bar.log'))
    end
  end

  describe '--stderr' do
    let(:opts) do
      @opts.merge(
        '--daemon' => true,
        '--stderr' => '~/foo/bar.log')
    end

    it_should_behave_like 'valid agent'

    it 'should parse env option' do
      agent = CLI::OptionParser.new(opts, @argv).agent
      plist = agent2plist(agent)

      plist['StandardErrorPath'].should eql(File.expand_path('~/foo/bar.log'))
    end
  end

  describe 'interval' do
    let(:opts) do
      @opts.merge(
        '--interval' => "120")
    end

    it_should_behave_like 'valid agent'

    it 'should parse env option' do
      agent = CLI::OptionParser.new(opts, @argv).agent
      plist = agent2plist(agent)

      plist['StartInterval'].should eql(120)
    end
  end

  def agent2plist(agent)
    Plist.parse_xml(agent.plist_content)
  end
end
