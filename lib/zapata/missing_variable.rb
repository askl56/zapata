module Zapata
  class Missing
    def initialize(*parameters)
      @parameters = parameters
    end

    def to_s
      printable_params = @parameters.map do |param|
        Writer.arg_for_print(param)
      end

      "Zapata::Missing.new(#{printable_params.join(', ')})"
    end

    def method_missing(m, *args, &block)
      binding.pry
      self
    end
  end
end