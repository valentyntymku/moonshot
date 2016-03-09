require 'moonshot/shell'

module Moonshot::BuildMechanism
  # This simply waits for Travis-CI to finish building a job matching the
  # version and 'BUILD=1'.
  class TravisDeploy
    include Moonshot::ResourcesHelper
    include Moonshot::DoctorHelper
    include Moonshot::Shell

    attr_reader :output_file

    def initialize(slug, pro: false)
      @slug = slug
      @endpoint = pro ? '--pro' : '--org'
      @cli_args = "-r #{@slug} #{@endpoint}"
    end

    def pre_build_hook(_)
    end

    def build_hook(version)
      job_number = find_build_and_job(version)
      wait_for_job(job_number)
      check_build(version)
    end

    def post_build_hook(_)
    end

    private

    def find_build_and_job(version)
      job_number = nil
      ilog.start_threaded('Find Travis CI build') do |step|
        sleep 2
        build_out = sh_out("bundle exec travis show #{@cli_args} #{version}")
        unless (job_number = build_out.match(/^#(\d+\.\d+) .+BUILD=1.+/)[1])
          raise "Build for #{version} not found.\n#{build_out}"
        end
        step.success("Travis CI ##{job_number.gsub(/\..*/, '')} running.")
      end
      job_number
    end

    def wait_for_job(job_number)
      cmd = "bundle exec travis logs #{@cli_args} #{job_number}"
      # This log tailing fails at the end of the file. travis bug.
      sh_step(cmd, fail: false)
    end

    def check_build(version)
      cmd = "bundle exec travis show #{@cli_args} #{version}"
      sh_step(cmd) do |step, out|
        raise "Build didn't pass.\n#{build_out}" \
          if out =~ /^#(\d+\.\d+) (?!passed).+BUILD=1.+/

        step.success("Travis CI build for #{version} passed.")
      end
    end

    def doctor_check_travis_auth
      sh_out("bundle exec travis raw #{@endpoint} repos/#{@slug}")
    rescue => e
      critical "`travis` not available or not authorized.\n#{e.message}"
    else
      success '`travis` installed and authorized.'
    end
  end
end
