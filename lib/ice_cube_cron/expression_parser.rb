module IceCubeCron # :nodoc:
  ##
  # Parses the incoming expression and splits it into meaningful parts.
  #
  class ExpressionParser
    include ::IceCubeCron::ParserAttribute

    EXPRESSION_PART_DEFAULTS = {
      :repeat_interval => 1,
      :repeat_year => nil,
      :repeat_month => nil,
      :repeat_day => nil,
      :repeat_weekday => nil,
      :repeat_hour => nil,
      :repeat_minute => nil,
      :repeat_until => nil
    }

    EXPRESSION_PART_KEYS = [
      :repeat_minute,
      :repeat_hour,
      :repeat_day,
      :repeat_month,
      :repeat_weekday,
      :repeat_year
    ]

    ##
    # Create a parsed expression
    #
    # Takes a hash of cron expression parts.
    #
    # ### Expression values:
    # - interval
    # - year
    # - month
    # - day
    # - weekday
    def initialize(*expression)
      expression_parts = expression.last.is_a?(::Hash) ? expression.last : {}

      expression_str = expression[0].is_a?(::String) ? expression[0] : nil
      expression_parts.merge!(string_to_expression_parts(expression_str))

      self.expression_hash = EXPRESSION_PART_DEFAULTS.dup

      expression_parts.each do |name, val|
        send("#{name}=", val)
      end
    end

    parser_attribute_accessor :interval do |val|
      ExpressionParser.sanitize_integer_param(val, 1)
    end

    parser_attribute_accessor :day do |val|
      ExpressionParser.sanitize_day_param(val)
    end

    parser_attribute_accessor :month do |val|
      ExpressionParser.sanitize_integer_array_param(val)
    end

    parser_attribute_accessor :until

    parser_attribute_accessor :year do |val|
      ExpressionParser.sanitize_integer_array_param(val)
    end

    parser_attribute_accessor :weekday do |val|
      ExpressionParser.sanitize_week_day_param(val)
    end

    parser_attribute_accessor :hour do |val|
      ExpressionParser.sanitize_integer_array_param(val)
    end

    parser_attribute_accessor :minute do |val|
      ExpressionParser.sanitize_integer_array_param(val)
    end

    ##
    # Split string expression into parts
    #
    def string_to_expression_parts(expression_str)
      return {} if expression_str.nil?

      parts = expression_str.split(/ +/)

      expression_parts = ::Hash[EXPRESSION_PART_KEYS.zip(parts)]
      expression_parts.select! do |_key, value|
        next false if value.nil?
        next false if value == '*'

        true
      end

      expression_parts
    end

    ##
    # Sanitize given value to an integer
    #
    def self.sanitize_integer_param(param, default = nil)
      return default if param.blank?

      param.to_i
    end

    ##
    # Sanitize given value to a valid day parameter
    #
    def self.sanitize_day_param(param)
      return nil if param.blank?
      return param if param.is_a?(::Array)
      return [param] if param.is_a?(::Integer)

      param.to_s.split(',').map do |element|
        next -1 if element == 'L'

        ExpressionParser.sanitize_integer_array_param(element)
      end.flatten.uniq
    end

    ##
    # Sanitize given value to a valid weekday parameter
    #
    def self.sanitize_week_day_param(param)
      return nil if param.blank?
      param.to_s.split(',').map do |element|
        if element =~ /[0-9]+#[0-9]+/
          parts = element.split('#')
          { ExpressionParser.sanitize_integer_param(parts[0]) => ExpressionParser.sanitize_integer_array_param(parts[1]) }
        elsif element =~ /[0-9]+L/
          { ExpressionParser.sanitize_integer_param(element) => [-1] }
        else
          ExpressionParser.sanitize_integer_param(element)
        end
      end
    end

    ##
    # Sanitize given value to an integer array
    #
    #--
    # rubocop:disable Metrics/AbcSize
    #++
    def self.sanitize_integer_array_param(param)
      return nil if param.blank?
      return param if param.is_a?(::Array)
      return [param] if param.is_a?(::Integer)

      param.split(',').map do |element|
        if element =~ /[0-9]+\-[0-9]+/
          parts = element.split('-')
          (parts[0].to_i..parts[1].to_i).to_a
        else
          element.to_i
        end
      end.flatten.uniq
    end
    # rubocop:enable Metrics/AbcSize
  end
end
