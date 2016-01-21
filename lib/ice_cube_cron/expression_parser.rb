module IceCubeCron # :nodoc:
  ##
  # Parses the incoming expression and splits it into meaningful parts.
  #
  class ExpressionParser
    include ::IceCubeCron::ParserAttribute

    EXPRESSION_PART_DEFAULTS = {
      :interval => 1,
      :year => nil,
      :month => nil,
      :day_of_month => nil,
      :day_of_week => nil,
      :hour => nil,
      :minute => nil,
      :until => nil
    }

    EXPRESSION_PART_KEYS = [
      :minute,
      :hour,
      :day_of_month,
      :month,
      :day_of_week,
      :year
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
        begin
          send("#{name}=", val)
        rescue NoMethodError
          raise ArgumentError, "Invalid parameter: #{name}"
        end
      end
    end

    parser_attribute_accessor :interval do |val|
      ExpressionParser.sanitize_integer_param(val, 1)
    end

    parser_attribute_accessor :day_of_month do |val|
      ExpressionParser.sanitize_day_param(val)
    end
    _define_parser_attribute_aliases(:day, :day_of_month, :day_of_month=)

    parser_attribute_accessor :month do |val|
      ExpressionParser.sanitize_integer_array_param(val)
    end

    parser_attribute_accessor :year do |val|
      ExpressionParser.sanitize_integer_array_param(val)
    end

    parser_attribute_accessor :day_of_week do |val|
      ExpressionParser.sanitize_week_day_param(val)
    end
    _define_parser_attribute_aliases(:weekday, :day_of_week, :day_of_week=)

    parser_attribute_accessor :hour do |val|
      ExpressionParser.sanitize_integer_array_param(val)
    end

    parser_attribute_accessor :minute do |val|
      ExpressionParser.sanitize_integer_array_param(val)
    end

    parser_attribute_accessor :until do |val|
      ::IceCubeCron::Util.sanitize_date_param(val)
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
    # Sanitize given value to an integer
    #
    def self.sanitize_integer_param(param, default = nil)
      return default if param.blank?

      param.to_i
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

  private

    ##
    # Split a cron string and extract the LAST interval that appears
    #
    def split_parts_and_interval(expression_str)
      interval = nil
      parts = expression_str.split(/ +/).map do |part|
        part, part_interval = part.split('/')
        interval = part_interval unless part_interval.blank?
        next nil if part.blank? || part == '*'

        part
      end

      [parts, interval]
    end

    ##
    # Split string expression into parts
    #
    def string_to_expression_parts(expression_str)
      return {} if expression_str.nil?

      parts, interval = split_parts_and_interval(expression_str)

      expression_parts = ::Hash[EXPRESSION_PART_KEYS.zip(parts)]
      expression_parts.select! do |_key, value|
        !value.nil?
      end
      expression_parts.merge!(:interval => interval) unless interval.nil?

      expression_parts
    end
  end
end
