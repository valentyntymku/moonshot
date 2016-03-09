module Moonshot
  # Displays information about existing stack parameters to the user, with
  # information on what a stack update would do.
  class StackParameterPrinter
    def initialize(stack, table)
      @stack = stack
      @table = table
    end

    def print # rubocop:disable AbcSize
      p_table = @table.add_leaf('Stack Parameters')
      overrides = @stack.overrides
      rows = @stack.parameters.sort_by(&:parameter_key).map do |parm|
        t_param = @stack.template.parameters.find do |p|
          p.name == parm.parameter_key
        end

        properties = determine_change(t_param ? t_param.default : nil,
                                      overrides[parm.parameter_key],
                                      parm.parameter_value)

        [
          parm.parameter_key << ':',
          format_value(parm.parameter_value),
          format_properties(properties)
        ]
      end

      p_table.add_table(rows)
    end

    def determine_change(default, override, current)
      properties = []

      # If there is a stack override, determine if it would change the current
      # stack.
      if override
        properties << 'overridden'
        if current == '****'
          properties << 'may be updated, NoEcho set'
        elsif override != current
          properties << "would be updated to #{override}"
        end

      else
        # Otherwise, compare the template default with the current value to
        # determine outcome.
        properties << 'default'
        properties << "would be updated to #{default}" if default != current
      end

      properties
    end

    def format_properties(properties)
      string = " (#{properties.join(', ')})"

      if properties.any? { |p| p =~ /be updated/ }
        string.yellow
      else
        string.green
      end
    end

    def format_value(value)
      if value.size > 40
        value[0..40] + '...'
      else
        value
      end
    end
  end
end
