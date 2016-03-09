module Moonshot
  # Resources is a dependency container that holds references to instances
  # provided to a Mechanism (build, deploy, etc.).
  class Resources
    attr_reader :log, :stack, :ilog

    def initialize(log:, stack:, ilog:)
      @log = log
      @stack = stack
      @ilog = ilog
    end
  end
end
