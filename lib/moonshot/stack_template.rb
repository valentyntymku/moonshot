require 'json'

module Moonshot
  # A StackTemplate loads the JSON template from disk and stores information
  # about it.
  class StackTemplate
    Parameter = Struct.new(:name, :default) do
      def required?
        default.nil?
      end
    end

    attr_reader :body

    def initialize(filename, log:)
      @log = log

      unless File.exist?(filename)
        @log.error("Could not find CloudFormation template at #{filename}")
        raise
      end

      # The maximum TemplateBody length is 51,200 bytes, so we remove
      # formatting white space.
      @body = JSON.parse(File.read(filename)).to_json
    end

    def parameters
      JSON.parse(@body).fetch('Parameters', {}).map do |k, v|
        Parameter.new(k, v['Default'])
      end
    end

    # Return a list of defined resource names in the template.
    def resource_names
      JSON.parse(@body).fetch('Resources', {}).keys
    end
  end
end
