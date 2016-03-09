module Moonshot
  # Display the stack outputs to the user.
  class StackOutputPrinter
    def initialize(stack, table)
      @stack = stack
      @table = table
    end

    def print
      o_table = @table.add_leaf('Stack Outputs')
      @stack.outputs.each do |k, v|
        o_table.add_line("#{k}: #{v}")
      end
    end
  end
end
