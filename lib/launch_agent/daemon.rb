module LaunchAgent
  class Daemon < Base
    def build_params
      @params['Label'] = job_id
      @params['KeepAlive'] = {
        'SuccessfulExit' => false
      }
      @params['ProgramArguments'] = @args
      @params['RunAtLoad'] = true
    end
  end
end
