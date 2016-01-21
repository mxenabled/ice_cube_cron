module IceCubeCron # :nodoc: all
  module ParserAttribute # :nodoc:
    def self.included(base)
      base.extend(::IceCubeCron::ParserAttribute::ClassMethods)
    end

  private

    attr_accessor :expression_hash

    module ClassMethods # :nodoc:
      def parser_attribute_accessor(attr_name, &cleanser)
        getter = attr_name.to_s.to_sym
        setter = "#{attr_name}=".to_sym

        define_method(getter) do
          expression_hash[getter]
        end

        define_method(setter) do |val|
          val = yield val if cleanser
          expression_hash[getter] = val
        end

        _define_parser_attribute_aliases(attr_name, getter, setter)
      end

    private

      def _define_parser_attribute_aliases(attr_name, getter, setter)
        alias_method "repeat_#{attr_name}=".to_sym, setter
        alias_method "repeat_#{attr_name}".to_sym, getter
        alias_method "cron_#{attr_name}=".to_sym, setter
        alias_method "cron_#{attr_name}".to_sym, getter
      end
    end
  end
end
