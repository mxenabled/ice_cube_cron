module IceCubeCron
  class RuleBuilder
    def build_rule(params)
      rule = build_root_recurrence_rule(params)
      rule = rule.month_of_year(*params[:month]) unless params[:month].blank?
      rule = rule.day_of_month(*params[:day]) unless params[:day].blank?
      rule = build_weekday_rule(rule, params)

      rule
    end

    def build_weekday_rule(rule, params)
      return rule.day_of_week(*params[:weekday]) if !params[:weekday].blank? && nth_day?(params[:weekday])
      return rule.day(*params[:weekday]) unless params[:weekday].blank?

      rule
    end

    # rubocop:disable Metrics/AbcSize
    def build_root_recurrence_rule(params)
      return ::IceCube::Rule.yearly(params[:interval]) unless params[:month].blank?
      return ::IceCube::Rule.monthly(params[:interval]) if !params[:weekday].blank? && nth_day?(params[:weekday])
      return ::IceCube::Rule.weekly(params[:interval]) unless params[:weekday].blank?

      ::IceCube::Rule.monthly(params[:interval])
    end
    # rubocop:enable Metrics/AbcSize

    def nth_day?(param)
      return false if param.nil? || param.empty?
      param[0].is_a?(::Hash)
    end
  end
end
