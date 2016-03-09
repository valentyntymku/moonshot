module Moonshot
  describe BuildMechanism::GithubRelease do
    let(:build_mechanism) do
      instance_double(BuildMechanism::Script).as_null_object
    end

    let(:resources) do
      Resources.new(
        ilog: instance_double(InteractiveLogger).as_null_object,
        log: instance_double(Logger).as_null_object,
        stack: instance_double(Stack).as_null_object
      )
    end

    let(:slug) { 'myorg/myrepo' }

    subject do
      s = described_class.new(build_mechanism)
      s.resources = resources
      s
    end

    describe '#doctor_hook' do
      it 'should call our hooks' do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:print)
        expect(subject).to receive(:doctor_check_hub_auth)
        expect(subject).to receive(:doctor_check_upstream)
        subject.doctor_hook
      end

      describe '#doctor_check_upstream' do
        around do |example|
          Dir.mktmpdir do |path|
            Dir.chdir(path) do
              `git init`
              example.run
            end
          end
        end

        it 'should fail without upstream.' do
          expect(subject).to receive(:critical)
            .with(/git remote `upstream` not found/)
          subject.send(:doctor_check_upstream)
        end

        it 'should succeed with upstream remote.' do
          `git remote add upstream https://example.com/my/repo.git`
          expect(subject).to receive(:success)
            .with('git remote `upstream` exists.')
          subject.send(:doctor_check_upstream)
        end
      end

      describe '#doctor_check_hub_auth' do
        it 'should succeed with 0 exit status.' do
          expect(subject).to receive(:sh_out)
            .with('hub ci-status 0.0.0')
          expect(subject).to receive(:success)
            .with('`hub` installed and authorized.')
          subject.send(:doctor_check_hub_auth)
        end

        it 'should critical with non-zero exit status.' do
          expect(subject).to receive(:sh_out)
            .with('hub ci-status 0.0.0')
            .and_raise(RuntimeError, 'oops')
          expect(subject).to receive(:critical)
            .with("`hub` failed, install hub and authorize it.\noops")
          subject.send(:doctor_check_hub_auth)
        end
      end
    end
  end
end
