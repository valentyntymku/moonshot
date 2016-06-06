require 'highline/import'
require_relative 'unicode_table'

module Moonshot
  module ParameterStrategy
    # Merge strategy: prefer parameter values defined in the parameter file,
    # otherwise use the previously set value on the existing stack.
    class MergeStrategy
      def parameters(params, stack_params, template)
        stack_keys = stack_params.keys.select do |k|
          template.parameters.any? { |p| p.name == k }
        end

        (params.keys + stack_keys).uniq.map do |key|
          if params[key]
            {
              parameter_key: key,
              parameter_value: params[key],
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
