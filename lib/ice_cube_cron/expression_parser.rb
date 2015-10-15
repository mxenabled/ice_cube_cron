module IceCubeCron
  class ExpressionParser
    attr_accessor :expression_hash

    def initialize(exp)
      self.expression_hash = {
        :repeat_interval => 1,
        :repeat_year => nil,
        :repeat_month => nil,
        :repeat_day => nil,
        :repeat_weekday => nil
      }

      if exp.is_a?(::Hash)
        exp.each do |name, val|
          send("#{name}=", val)
        end
      elsif exp.is_a?(::String)
        fail ArgumentError, 'string cron expressions are not yet supported'
      end
    end

    def [](val_name)
      send(val_name)
    end

    def []=(val_name, new_val)
      send("#{val_name}=", new_val)
    end

    def interval
      expression_hash[:repeat_interval]
    end
    alias_method :repeat_interval, :interval

    def interval=(val)
      expression_hash[:repeat_interval] = sanitize_integer_param(val, 1)
    end
    alias_method :repeat_interval=, :interval=

    def day
      expression_hash[:repeat_day]
    end
    alias_method :repeat_day, :day

    def day=(val)
      expression_hash[:repeat_day] = sanitize_day_param(val)
    end
    alias_method :repeat_day=, :day=

    def month
      expression_hash[:repeat_month]
    end
    alias_method :repeat_month, :month

    def month=(val)
      expression_hash[:repeat_month] = sanitize_integer_array_param(val)
    end
    alias_method :repeat_month=, :month=

    def year
      expression_hash[:repeat_year]
    end
    alias_method :repeat_year, :year

    def year=(val)
      expression_hash[:repeat_year] = sanitize_integer_array_param(val)
    end
    alias_method :repeat_year=, :year=

    def weekday
      expression_hash[:repeat_weekday]
    end
    alias_method :repeat_weekday, :weekday

    def weekday=(val)
      expression_hash[:repeat_weekday] = sanitize_week_day_param(val)
    end
    alias_method :repeat_weekday=, :weekday=

  private

    def sanitize_integer_param(param, default = nil)
      return default if param.blank?

      param.to_i
    end

    def sanitize_day_param(param)
      return nil if param.blank?
      return param if param.is_a?(::Array)
      return [param] if param.is_a?(::Integer)

      param.to_s.split(',').map do |element|
        next -1 if element == 'L'

        element.to_i
      end
    end

    def sanitize_week_day_param(param)
      return nil if param.blank?
      param.to_s.split(',').map do |element|
        if element =~ /[0-9]+#[0-9]+/
          parts = element.split('#')
          { sanitize_integer_param(parts[0]) => sanitize_integer_array_param(parts[1]) }
        elsif element =~ /[0-9]+L/
          { sanitize_integer_param(element) => [-1] }
        else
          sanitize_integer_param(element)
        end
      end
    end

    def sanitize_integer_array_param(param)
      return nil if param.blank?
      return param if param.is_a?(::Array)
      return [param] if param.is_a?(::Integer)

      param.split(',').map(&:to_i)
    end
  end
end
