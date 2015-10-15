module IceCube
  class << self
    def from_cron(start_time, expression = {})
      expression_parser = ::IceCubeCron::ExpressionParser.new(expression)
      rule = ::IceCubeCron::RuleBuilder.new.build_rule(expression_parser)

      schedule = ::IceCube::Schedule.new(::IceCubeCron::Util.sanitize_date_param(start_time))
      schedule.add_recurrence_rule(rule)

      schedule
    end
  end
end
