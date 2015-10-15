module IceCubeCron
  class IceCubeCronInterpreter
    attr_accessor :expression

    def initialize(exp)
      self.expression = {
        :repeat_interval => nil,
        :repeat_year => nil,
        :repeat_month => nil,
        :repeat_day => nil,
        :repeat_weekday => nil
      }.merge(exp)
    end

    def schedule_rules
      sanitize_params(expression)
    end

    def sanitize_params(expression)
      {
        :repeat_interval => ::IceCubeCron::Util.sanitize_integer_param(expression[:repeat_interval]),
        :repeat_year => ::IceCubeCron::Util.sanitize_integer_array_param(expression[:repeat_year]),
        :repeat_month => ::IceCubeCron::Util.sanitize_integer_array_param(expression[:repeat_month]),
        :repeat_day => ::IceCubeCron::Util.sanitize_day_param(expression[:repeat_day]),
        :repeat_weekday => ::IceCubeCron::Util.sanitize_week_day_param(expression[:repeat_weekday])
      }
    end
  end
end
