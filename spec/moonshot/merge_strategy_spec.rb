describe Moonshot::ParameterStrategy::MergeStrategy do
  subject { described_class.new }

  describe '#parameters' do
    subject do
      super().parameters(
        parameters,
        stack_parameters,
        template
      )
    end

    let(:parameters) do
      {
        file_parameter_1: 'file_parameter_1',
        file_parameter_2: 'file_parameter_2'
      }
    end

    let(:stack_parameters) do
      {
        stack_parameter_1: 'stack_parameter_1',
        stack_parameter_2: 'stack_parameter_2'
      }
    end

    let(:template_parameters) do
      [
        double('template_param', name: :stack_parameter_1),
        double('template_param', name: :stack_parameter_2)
      ]
    end

    let(:template) do
      template = double(Moonshot::StackTemplate)
      allow(template).to receive(:parameters).and_return(template_parameters)
      template
    end

    let(:actual_keys) do
      subject.map { |p| p[:parameter_key] }
    end

    it 'includes the stack and YAML file parameters' do
      expected_keys = (parameters.keys + stack_parameters.keys).uniq
      expect(actual_keys).to eq(expected_keys)
    end

    context 'when the template no longer includes a stack parameter' do
      let(:removed_element) do
        template_parameters.pop
      end

      it 'does not include the removed parameter' do
        removed_key = removed_element.name
        expect(actual_keys).not_to include(removed_key)
      end
    end

    context 'when the template adds a new parameter and it is provided' do
      let(:added_parameter) do
        double('template_param', name: :template_parameter_1)
      end

      let(:template_parameters) do
        super().insert(added_parameter)
      end

      let(:parameters) do
        parameters = super()
        parameters[added_parameter.name] = 'template_parameter_1'
        parameters
      end

      it 'includes the added parameter' do
        expect(actual_keys).to include(added_parameter.name)
      end
    end
  end
end
