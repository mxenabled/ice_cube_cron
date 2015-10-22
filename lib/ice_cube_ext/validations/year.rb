module IceCube
  module Validations
    ##
    # Allows addition of a year (non-standard cron) to the repeat rules.
    #
    module Year
      ##
      # Call to filter occurrences to one or more years.
      #
      def year(*years)
        years.flatten.each do |year|
          unless year.is_a?(Fixnum)
            raise ArgumentError, "expecting Fixnum value for year, got #{year.inspect}"
          end
          validations_for(:year) << Validation.new(year)
        end
        ::IceCube::Validations::FixedValue::INTERVALS[:year] = 100
        self
      end

      class Validation < Validations::FixedValue # :nodoc:
        attr_reader :year
        alias_method :value, :year

        def initialize(year)
          @year = year
        end

        def type
          :year
        end

        def dst_adjust?
          true
        end

        def build_s(builder)
          builder.piece(:year) << StringBuilder.nice_number(year)
        end

        def build_hash(builder)
          builder.validations_array(:year) << year
        end

        def build_ical(builder)
          builder['BYYEAR'] << year
        end

        StringBuilder.register_formatter(:year) do |entries|
          "in #{StringBuilder.sentence(entries)} "
        end
      end
    end
  end
end
