module Moonshot
  module ParameterStrategy
    # Default strategy: grabbing every parameter
    # from the parameter file.
    class DefaultStrategy
      def parameters(_, overrides)
        overrides.map do |key, _|
          {
            parameter_key: key,
            parameter_value: overrides[key],
            use_previous_value: false
          }
        end
      end
    end
  end
end
