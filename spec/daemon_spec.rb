require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe LaunchAgent::Daemon do
  before do
    @plist_filename = File.expand_path('~/Library/LaunchAgents/com.buycheapviagraonlinenow.ruby__foo_rb.plist')
    @agent = LaunchAgent::Daemon.new('ruby', 'foo.rb')
  end

  after do
    `launchctl unload -w #{@plist_filename}` if `launchctl list | grep ruby__foo_rb` =~ /ruby__foo.rb/
    File.unlink(@plist_filename) if File.exists?(@plist_filename)
  end

  it 'shuld load and unload' do
    @agent.should_not be_loaded

    @agent.load

    @agent.should be_loaded

    File.exists?(@plist_filename).should be_true
    open(@plist_filename).read.should eql(<<PLIST)
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.buycheapviagraonlinenow.ruby__foo_rb</string>
	<key>ProgramArguments</key>
	<array>
		<string>ruby</string>
		<string>foo.rb</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
PLIST

    (`launchctl list | grep ruby__foo_rb` =~ /ruby__foo.rb/).should_not be_nil

    @agent.unload

    File.exists?(@plist_filename).should be_false
    (`launchctl list | grep ruby__foo_rb` =~ /ruby__foo.rb/).should be_nil
  end
end
