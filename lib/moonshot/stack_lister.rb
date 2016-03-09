module Moonshot
  # The StackLister is world renoun for it's ability to list stacks.
  class StackLister
    include CredsHelper

    def initialize(app_name, log:)
      @app_name = app_name
      @log = log
    end

    def list
      all_stacks = cf_client.describe_stacks.stacks
      app_stacks = all_stacks.reject { |s| s.stack_name !~ /^#{@app_name}/ }

      app_stacks.each do |stack|
        puts stack.stack_name
      end
    end
  end
end
