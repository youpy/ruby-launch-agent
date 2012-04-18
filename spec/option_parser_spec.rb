require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include LaunchAgent

describe CLI::OptionParser do
  before do
    @argv = %w/ruby foo.rb/
    @opts = {
      :env => []
    }

    @agent = CLI::OptionParser.new(opts, @argv).agent
    @plist = agent2plist(@agent)
  end

  shared_examples_for 'valid agent' do
    it "should have necessary attributes" do
      @plist['Label'].should eql('com.buycheapviagraonlinenow.ruby__foo_rb')
      @plist['ProgramArguments'].should eql(@argv)
    end
  end

  describe 'damon' do
    let(:opts) do
      @opts.merge(
        :daemon => true)
    end

    it_should_behave_like 'valid agent'

    it 'should parse damon option' do
      @plist['KeepAlive'].should eql({
          'SuccessfulExit' => false
        })
      @plist['RunAtLoad'].should be_true
    end
  end

  describe 'wdir' do
    let(:opts) do
      @opts.merge(
        :daemon => true,
        :wdir => '/foo/bar')
    end

    it_should_behave_like 'valid agent'

    it 'should parse wdir option' do
      @plist['WorkingDirectory'].should eql('/foo/bar')
    end
  end

  describe 'env' do
    let(:opts) do
      @opts.merge(
        :daemon => true,
        :env => ['FOO=BAR','BAR=BAZ'])
    end

    it_should_behave_like 'valid agent'

    it 'should parse env option' do
      @plist['EnvironmentVariables'].should eql({ 'FOO' => 'BAR', 'BAR' => 'BAZ' })
    end
  end

  describe 'interval' do
    let(:opts) do
      @opts.merge(
        :interval => 120)
    end

    it_should_behave_like 'valid agent'

    it 'should parse env option' do
      @plist['StartInterval'].should eql(120)
    end
  end

  def agent2plist(agent)
    Plist.parse_xml(agent.plist_content)
  end
end
