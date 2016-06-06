module Moonshot
  module ParameterStrategy
    # Default strategy: use parameter defined in the parameter file
    class DefaultStrategy
      def parameters(params, _, _)
        params.map do |key, _|
          {
            parameter_key: key,
            parameter_value: params[key],
            use_previous_value: false
          }
        end
      end
    end
  end
end
