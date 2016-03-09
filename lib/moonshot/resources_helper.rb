module Moonshot
  # Provides shorthand methods for accessing resources provided by the Resources
  # container.
  module ResourcesHelper
    attr_writer :resources

    private

    def log
      raise 'Resources not provided to Mechanism!' unless @resources
      @resources.log
    end

    def stack
      raise 'Resources not provided to Mechanism!' unless @resources
      @resources.stack
    end

    def ilog
      raise 'Resources not provided to Mechanism!' unless @resources
      @resources.ilog
    end
  end
end
