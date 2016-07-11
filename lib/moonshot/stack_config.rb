module Moonshot
  # Configuration for the Moonshot::Stack class.
  class StackConfig
    attr_accessor :parent_stacks
    attr_accessor :show_all_events
    attr_accessor :parameter_strategy
    attr_accessor :ssh_instance
    attr_accessor :ssh_identity_file
    attr_accessor :ssh_user
    attr_accessor :ssh_command
    attr_accessor :ssh_auto_scaling_group_name

    def initialize
      @parent_stacks = []
      @show_all_events = false
    end
  end
end
