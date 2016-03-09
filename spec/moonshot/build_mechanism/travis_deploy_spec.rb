module Moonshot
  describe BuildMechanism::TravisDeploy do
    let(:resources) do
      Resources.new(
        ilog: double(InteractiveLogger).as_null_object,
        log: double(Logger).as_null_object,
        stack: double(Stack).as_null_object
      )
    end
    let(:slug) { 'myorg/myrepo' }

    subject do
      s = described_class.new(slug)
      s.resources = resources
      s
    end

    describe '#doctor_hook' do
      it 'should call our hooks' do
        allow(subject).to receive(:puts)
        expect(subject).to receive(:puts).with('we did it')
        expect(subject).to receive(:print).with('  ✓ '.green)
        expect(subject).to receive(:doctor_check_travis_auth) do
          subject.send(:success, 'we did it')
        end
        subject.doctor_hook
      end

      describe '#doctor_check_travis_auth' do
        it 'should pass if travis exits 0' do
          expect(subject).to receive(:sh_out)
            .with('bundle exec travis raw --org repos/myorg/myrepo')
          expect(subject).to receive(:success)
            .with('`travis` installed and authorized.')
          subject.send(:doctor_check_travis_auth)
        end

        it 'should pass fail travis exits 1' do
          expect(subject).to receive(:sh_out)
            .with('bundle exec travis raw --org repos/myorg/myrepo')
            .and_raise(RuntimeError, 'stuffs broke man')
          expect(subject).to receive(:critical)
            .with("`travis` not available or not authorized.\nstuffs broke man")
          subject.send(:doctor_check_travis_auth)
        end
      end
    end
  end
end
