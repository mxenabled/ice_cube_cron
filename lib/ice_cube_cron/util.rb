# frozen_string_literal: true

module IceCubeCron # :nodoc: all
  ##
  # :category: Utilities
  #
  module Util
    def self.sanitize_date_param(date)
      date = Date.parse(date) if date.is_a?(::String)
      date = date.to_time(:utc) if date.is_a?(::Date) && !date.is_a?(::DateTime)
      date = date.to_time.utc if date.is_a?(::DateTime)
      date = Time.at(date).utc if date.is_a?(::Integer)

      date
    end
  end
end
