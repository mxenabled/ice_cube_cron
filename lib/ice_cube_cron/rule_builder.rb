module IceCubeCron # :nodoc:
  ##
  # Generates Rules based on parsed expression
  #
  class RuleBuilder
    ##
    # Generates a rule based on a parsed expression
    #
    def build_rule(expression)
      rule = build_root_recurrence_rule(expression)
      rule = build_yearly_rules(rule, expression)
      rule = build_weekday_rule(rule, expression)
      rule = rule.day_of_month(*expression.day) unless expression.day.blank?
      rule = rule.until(expression.until) unless expression.until.blank?

      rule
    end

    # :nodoc:
    def nth_day?(param)
      return false if param.nil? || param.empty?
      param[0].is_a?(::Hash)
    end

  private

    # :nodoc:
    def build_weekday_rule(rule, expression)
      return rule.day_of_week(*expression.weekday) if !expression.weekday.blank? && nth_day?(expression.weekday)
      return rule.day(*expression.weekday) unless expression.weekday.blank?

      rule
    end

    # :nodoc:
    def build_yearly_rules(rule, expression)
      rule = rule.year(*expression.year) unless expression.year.blank?
      rule = rule.month_of_year(*expression.month) unless expression.month.blank?

      rule
    end

    # rubocop:disable Metrics/AbcSize
    def build_root_recurrence_rule(expression) # :nodoc:
      return ::IceCube::Rule.yearly(expression.interval) unless expression.month.blank?
      return ::IceCube::Rule.monthly(expression.interval) if !expression.weekday.blank? && nth_day?(expression.weekday)
      return ::IceCube::Rule.monthly(expression.interval) unless expression.day.blank?
      return ::IceCube::Rule.weekly(expression.interval) unless expression.weekday.blank?

      ::IceCube::Rule.monthly(expression.interval)
    end
    # rubocop:enable Metrics/AbcSize
  end
end
