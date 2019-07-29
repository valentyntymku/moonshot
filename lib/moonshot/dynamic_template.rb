require 'erb'

module Moonshot
  class TemplateExists < StandardError; end
  class InvalidTemplate < StandardError; end

  class DynamicTemplate
    # A class to encapsulate template parameters, passing a hash to `process` is
    # only available from Ruby 2.5.
    class Parameters
      def initialize(parameters)
        parameters.each do |k, v|
          instance_variable_set("@#{k}".to_sym, v)
          # Adding an attribute reader for flexibility, this way you can add
          # either `@parameter` or just `parameter` to your template.
          self.class.send(:attr_reader, k.to_sym)
        end
      end

      def expose_binding
        binding
      end
    end

    def initialize(source:, parameters:, destination:)
      puts 'DT:'
      puts Moonshot.config.environment_name
      @source = File.read(source)
      @parameters = Parameters.new(parameters.(Moonshot.config.environment_name))
      @destination = destination
    end

    def pre_change(resources)
      puts 'hello from pre_change DT!'
    end

    def process
      validate_destination_exists
      new_template = generate_template

      validate_template(new_template)
      write_output(new_template)
    end

    private

    def validate_destination_exists
      return unless File.file?(@destination)
      raise TemplateExists, "Output file '#{@destination}' already exists."
    end

    def validate_template(template)
      Aws::CloudFormation::Client.new.validate_template(
        template_body: template
      )
    rescue Aws::CloudFormation::Errors::ValidationError => e
      raise InvalidTemplate, "Invalid template:\n#{e}"
    end

    def generate_template
      ERB.new(@source).result(@parameters.expose_binding)
    end

    def write_output(content)
      File.write(@destination, content)
    end
  end
end
