module LaunchAgent
  class Base
    DOMAIN = 'com.buycheapviagraonlinenow'
    KEYS = [
      'Label',
      'Disabled',
      'UserName',
      'GroupName',
      'inetdCompatibility',
      'LimitLoadToHosts',
      'LimitLoadFromHosts',
      'LimitLoadToSessionType',
      'Program',
      'ProgramArguments',
      'EnableGlobbing',
      'EnableTransactions',
      'OnDemand',
      'KeepAlive',
      'RunAtLoad',
      'RootDirectory',
      'WorkingDirectory',
      'EnvironmentVariables',
      'Umask',
      'TimeOut',
      'ExitTimeOut',
      'ThrottleInterval',
      'InitGroups',
      'WatchPaths',
      'QueueDirectories',
      'StartOnMount',
      'StartInterval',
      'StartCalendarInterval',
      'StandardInPath',
      'StandardOutPath',
      'StandardErrorPath',
      'Debug',
      'WaitForDebugger',
      'SoftResourceLimits',
      'HardResourceLimits',
      'Nice',
      'AbandonProcessGroup',
      'LowPriorityIO',
      'LaunchOnlyOnce',
      'MachServices',
      'Sockets'
    ]

    def initialize(*args)
      @args = args
      @params = {}
      @user_params = {}
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

    def []=(key, value)
      if KEYS.include?(key)
        @user_params[key] = value
      end
    end

    def plist_filename
      File.expand_path('~/Library/LaunchAgents/' + job_id + '.plist')
    end

    def build_params
    end

    def plist_content
      build_params

      @params.merge(@user_params).to_plist
    end

    def job_id
      DOMAIN + '.' + @args.inject([]) do |m, arg|
        m << arg.to_s.gsub(/\W/, '_')
      end.join('__')
    end
  end
end
