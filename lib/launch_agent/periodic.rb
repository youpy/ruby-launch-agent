module LaunchAgent
  class Periodic < Base
    def initialize(interval_sec, *args)
      super(*args)
      @interval_sec = interval_sec
    end

    def build_params
      @params['Label'] = job_id
      @params['StartInterval'] = @interval_sec
      @params['ProgramArguments'] = @args
    end
  end
end
