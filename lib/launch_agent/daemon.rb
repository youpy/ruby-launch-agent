module LaunchAgent
  class Daemon
    DOMAIN = 'com.buycheapviagraonlinenow'

    def initialize(*args)
      @args = args
    end

    def load
      open(plist_filename, 'w') do |file|
        file.write(plist_content)
      end

      `launchctl load -w #{plist_filename}`
    end

    def unload
      `launchctl unload -w #{plist_filename}`
      File.unlink(plist_filename)
    end

    def loaded?
      `launchctl list | grep #{job_id}` =~ /#{job_id}/
    end

    def plist_filename
      File.expand_path('~/Library/LaunchAgents/' + job_id + '.plist')
    end

    def plist_content
      template = <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>%s</string>
	<key>ProgramArguments</key>
	<array>
%s
	</array>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
PLIST
      template % [job_id, xmlize_args]
    end

    def job_id
      DOMAIN + '.' + @args.inject([]) do |m, arg|
        m << arg.gsub(/\W/, '_')
      end.join('__')
    end

    def xmlize_args
      @args.inject([]) do |m, arg|
        m << "\t\t<string>#{arg}</string>"
      end.join("\n")
    end
  end
end
