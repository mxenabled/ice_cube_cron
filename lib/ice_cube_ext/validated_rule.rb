module IceCube
  class ValidatedRule < Rule # :nodoc:
    include Validations::Year
  end
end
