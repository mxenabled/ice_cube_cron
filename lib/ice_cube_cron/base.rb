module IceCube
  class << self
    def from_cron(start_time, expression = {})
      interpreter = ::IceCubeCron::IceCubeCronInterpreter.new(expression)
      ::IceCubeCron::Util.build_schedule(start_time, interpreter.schedule_rules)
    end
  end
end
