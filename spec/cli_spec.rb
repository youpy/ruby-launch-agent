require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'CLI' do
  before do
    @plist_filename = File.expand_path('~/Library/LaunchAgents/com.buycheapviagraonlinenow.ruby__foo_rb.plist')
  end

  after do
    `launchctl unload -w #{@plist_filename}` if `launchctl list | grep ruby__foo_rb` =~ /ruby__foo.rb/
    File.unlink(@plist_filename) if File.exists?(@plist_filename)
  end

  it 'should load/unload daemon-like agent' do
    command = File.expand_path(File.dirname(__FILE__) + '/../bin/launchagent --daemon --env FOO=BAR ruby foo.rb')

    system(command)

    File.exists?(@plist_filename).should be_true
    open(@plist_filename).read.should eql(<<PLIST)
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>EnvironmentVariables</key>
	<dict>
		<key>FOO</key>
		<string>BAR</string>
	</dict>
	<key>KeepAlive</key>
	<dict>
		<key>SuccessfulExit</key>
		<false/>
	</dict>
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

    system(command)

    File.exists?(@plist_filename).should be_false
    (`launchctl list | grep ruby__foo_rb` =~ /ruby__foo.rb/).should be_nil
  end

  it 'should load/unload periodic agent' do
    command = File.expand_path(File.dirname(__FILE__) + '/../bin/launchagent --interval 120 --env FOO=BAR ruby foo.rb')

    system(command)

    File.exists?(@plist_filename).should be_true
    open(@plist_filename).read.should eql(<<PLIST)
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>EnvironmentVariables</key>
	<dict>
		<key>FOO</key>
		<string>BAR</string>
	</dict>
	<key>Label</key>
	<string>com.buycheapviagraonlinenow.ruby__foo_rb</string>
	<key>ProgramArguments</key>
	<array>
		<string>ruby</string>
		<string>foo.rb</string>
	</array>
	<key>StartInterval</key>
	<integer>120</integer>
</dict>
</plist>
PLIST

    (`launchctl list | grep ruby__foo_rb` =~ /ruby__foo.rb/).should_not be_nil

    system(command)

    File.exists?(@plist_filename).should be_false
    (`launchctl list | grep ruby__foo_rb` =~ /ruby__foo.rb/).should be_nil
  end
end
