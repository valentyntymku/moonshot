module Moonshot
  class CommandLineDispatcher
    def initialize(command, klass, args)
      @command = command
      @klass = klass
      @args = args
    end

    def dispatch!
      # Look to see if we're allowed only to run in certain accounts, or
      # not allowed to run in specific accounts.
      check_account_restrictions
      handler = @klass.new
      handler.parser.parse!

      unless @args.size == handler.method(:execute).arity
        warn handler.parser.help
        raise "Invalid command line for '#{@command}'."
      end

      handler.execute(*@args)
    end

    private

    def check_account_restrictions
      this_account = Moonshot::AccountContext.get

      return if @klass.only_in_account.nil? ||
                Array(@klass.only_in_account).any? { |a| a == this_account }

      warn "'#{@command}' can only be run in the following accounts:"
      Array(@klass.only_in_account).each do |account_name|
        warn "- #{account_name}"
      end

      raise 'Command account restriction violation.'
    end
  end
end
