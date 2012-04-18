module LaunchAgent
  module CLI
    class OptionParser
      def initialize(opts, argv)
        @opts = opts
        @argv = argv
      end

      def agent
        raise 'full command must be supplied' if @argv.empty?

        daemon   = @opts[:daemon]
        interval = @opts[:interval]
        env      = @opts[:env]
        wdir     = @opts[:wdir]
        agent    = nil

        if daemon
          agent = LaunchAgent::Daemon.new(*@argv)
        elsif @opts[:interval]
          agent = LaunchAgent::Periodic.new(interval, *@argv)
        else
          raise 'at least one of --daemon and --interval must be set'
        end

        agent['EnvironmentVariables'] = env.inject({}) do |memo, e|
          k, v = e.split('=')
          memo[k] = v
          memo
        end

        if wdir
          agent['WorkingDirectory'] = File.expand_path(wdir)
        end

        agent
      end
    end
  end
end
