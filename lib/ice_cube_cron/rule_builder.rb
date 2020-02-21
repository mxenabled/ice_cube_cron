# frozen_string_literal: true

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
      rule = build_year_rules(rule, expression)
      rule = build_weekday_rule(rule, expression)
      rule = build_day_rules(rule, expression)
      rule = build_time_rules(rule, expression)
      rule = rule.until(expression.until) unless expression.until.blank?

      rule
    end

    # :nodoc:
    def nth_day?(param)
      return false if param.nil? || param.empty?

      param[0].is_a?(::Hash)
    end

  private

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def build_root_recurrence_rule(expression) # :nodoc:
      return ::IceCube::Rule.minutely(expression.interval) if expression.minute.blank?
      return ::IceCube::Rule.hourly(expression.interval) if expression.hour.blank?

      unless nth_day?(expression.day_of_week)
        return ::IceCube::Rule.weekly(expression.interval) if expression.day_of_month.blank? && !expression.day_of_week.blank?
        return ::IceCube::Rule.daily(expression.interval) if expression.day_of_month.blank?
      end
      return ::IceCube::Rule.monthly(expression.interval) if expression.month.blank?

      ::IceCube::Rule.yearly(expression.interval)
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    # :nodoc:
    def build_year_rules(rule, expression)
      rule = rule.year(*expression.year) unless expression.year.blank?
      rule = rule.month_of_year(*expression.month) unless expression.month.blank?

      rule
    end

    # :nodoc:
    def build_weekday_rule(rule, expression)
      return rule.day_of_week(*expression.day_of_week) if !expression.day_of_week.blank? && nth_day?(expression.day_of_week)
      return rule.day(*expression.day_of_week) unless expression.day_of_week.blank?

      rule
    end

    # :nodoc:
    def build_day_rules(rule, expression)
      rule = rule.day_of_month(*expression.day_of_month) unless expression.day_of_month.blank?

      rule
    end

    # :nodoc:
    def build_time_rules(rule, expression)
      rule = rule.hour_of_day(*expression.hour) unless expression.hour.blank? || expression.hour == [0]
      rule = rule.minute_of_hour(*expression.minute) unless expression.minute.blank? || expression.minute == [0]

      rule
    end
  end
end
