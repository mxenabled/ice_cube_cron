module IceCubeCron # :nodoc: all
  module ParserAttribute # :nodoc:
    def self.included(base)
      base.extend(::IceCubeCron::ParserAttribute::ClassMethods)
    end

    attr_accessor :expression_hash

    module ClassMethods # :nodoc:
      def parser_attribute_accessor(attr_name, &cleanser)
        getter = "repeat_#{attr_name}".to_sym
        setter = "repeat_#{attr_name}=".to_sym

        define_method(getter) do
          expression_hash[getter]
        end

        define_method(setter) do |val|
          val = cleanser.call(val) if cleanser
          expression_hash[getter] = val
        end

        alias_method attr_name, getter
        alias_method "#{attr_name}=".to_sym, setter
      end
    end
  end
end
