require_relative 'default_strategy'
require_relative 'merge_strategy'

module Moonshot
  # Holds configuration for Moonshot::Controller
  class ControllerConfig
    attr_accessor :app_name
    attr_accessor :artifact_repository
    attr_accessor :auto_prefix_stack
    attr_accessor :build_mechanism
    attr_accessor :deployment_mechanism
    attr_accessor :environment_name
    attr_accessor :interactive_logger
    attr_accessor :logger
    attr_accessor :parent_stacks
    attr_accessor :plugins
    attr_accessor :show_all_stack_events
    attr_reader :parameter_strategy

    def initialize
      @auto_prefix_stack = true
      @interactive_logger = InteractiveLogger.new
      @logger = Logger.new(STDOUT)
      @parent_stacks = []
      @plugins = []
      @show_all_stack_events = false
    end

    def parameter_strategy=(value)
      @parameter_strategy =
        case value.to_sym
        when :default
          Moonshot::ParameterStrategy::DefaultStrategy.new
        when :merge
          Moonshot::ParameterStrategy::MergeStrategy.new
        else
          raise Thor::Error, "Unknown parameter strategy: #{value}"
        end
    end
  end
end
