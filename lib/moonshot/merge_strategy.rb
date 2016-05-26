require 'highline/import'
require_relative 'unicode_table'

module Moonshot
  module ParameterStrategy
    # Merge strategy: merging parameter values
    # declared in the parameter file, otherwise
    # using previous value.
    class MergeStrategy
      def parameters(current, overrides)
        current.map do |key, _|
          if overrides[key]
            {
              parameter_key: key,
              parameter_value: overrides[key],
              use_previous_value: false
            }
          else
            {
              parameter_key: key,
              use_previous_value: true
            }
          end
        end
      end
    end
  end
end
