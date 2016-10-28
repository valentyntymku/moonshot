require_relative 'parameter_arguments'

module Moonshot
  module Commands
    class Update < Moonshot::Command
      include ParameterArguments

      self.usage = 'update [options]'
      self.description = 'Update the CloudFormation stack within an environment.'

      def parser
        parser = super

        parser.on('--dry-run', TrueClass, 'Show the changes that would be applied, but do not execute them') do |v|
          @dry_run = v
        end

        parser.on('--force', '-f', TrueClass, 'Apply ChangeSet without confirmation') do |v|
          @force = v
        end
      end

      def execute
        @force = true if !Moonshot.config.interactive
        controller.update(dry_run: @dry_run, force: @force)
      end
    end
  end
end
