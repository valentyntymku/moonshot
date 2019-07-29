module Moonshot
  module Plugins
    class DynamicTemplate
      def initialize(source:, parameters:, destination:)
        puts 'init plugin dynTemplates'
        @dynamic_template = ::Moonshot::DynamicTemplate.new(
          source: source,
          parameters: parameters,
          destination: destination
        )
      end

      def pre_create(res)
        puts 'DT pre_create hook!1'
        puts Moonshot.config.environment_name
        @dynamic_template.process
      end

      def run_hook
        puts 'Run hook...'
        @dynamic_template.process
      end

      # Moonshot hooks to trigger this plugin.
      alias post_cli run_hook
#      alias pre_update run_hook
#      alias setup_create run_hook
#      alias setup_update run_hook
    end
  end
end
