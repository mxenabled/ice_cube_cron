module IceCubeCron # :nodoc:
  ##
  # Parses the incoming expression and splits it into meaningful parts.
  #
  class ExpressionParser
    include ::IceCubeCron::ParserAttribute

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

    parser_attribute_accessor :interval do |val|
      ExpressionParser.sanitize_integer_param(val, 1)
    end

    parser_attribute_accessor :day do |val|
      ExpressionParser.sanitize_day_param(val)
    end

    parser_attribute_accessor :month do |val|
      ExpressionParser.sanitize_integer_array_param(val)
    end

    parser_attribute_accessor :year do |val|
      ExpressionParser.sanitize_integer_array_param(val)
    end

    parser_attribute_accessor :weekday do |val|
      ExpressionParser.sanitize_week_day_param(val)
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
