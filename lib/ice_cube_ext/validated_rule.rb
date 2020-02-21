# frozen_string_literal: true

module IceCube
  class ValidatedRule < Rule # :nodoc:
    include Validations::Year
  end
end
