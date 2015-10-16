module IceCubeCron # :nodoc:
  ##
  # This adds the `.from_cron` extension to the `::IceCube::Schedule` class
  #
  module Extension
    ##
    # Generates an ::IceCube::Schedule from a cron expression
    #
    # :args: start_time, expression
    #
    # ## Examples
    #
    # ```ruby
    # schedule = ::IceCube::Schedule.from_cron(::Date.current, "* * * * 5")
    #
    # schedule = ::IceCube::Schedule.from_cron(::Date.new(2015, 1, 5), :repeat_day => 5)
    #
    # schedule.occurrences_between(::Date.new(2015, 3, 5), ::Date.new(2015, 6, 5))
    # # => [2015-03-05 00:00:00 UTC, 2015-04-05 00:00:00 UTC, 2015-05-05 00:00:00 UTC, 2015-06-05 00:00:00 UTC]
    # ```
    def from_cron(start_time, expression = {})
      expression_parser = ::IceCubeCron::ExpressionParser.new(expression)
      rule = ::IceCubeCron::RuleBuilder.new.build_rule(expression_parser)

      schedule = ::IceCube::Schedule.new(::IceCubeCron::Util.sanitize_date_param(start_time))
      schedule.add_recurrence_rule(rule)

      schedule
    end
  end
end
