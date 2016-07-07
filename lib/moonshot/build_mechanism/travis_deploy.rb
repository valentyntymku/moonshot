require 'moonshot/shell'

module Moonshot::BuildMechanism
  # This simply waits for Travis-CI to finish building a job matching the
  # version and 'BUILD=1'.
  class TravisDeploy
    include Moonshot::ResourcesHelper
    include Moonshot::DoctorHelper
    include Moonshot::Shell

    MAX_BUILD_FIND_ATTEMPTS = 10

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
        job_number = wait_for_build(version)

        step.success("Travis CI ##{job_number.gsub(/\..*/, '')} running.")
      end
      job_number
    end

    # Looks for the travis build and attempts to retry if the build does not
    # exist yet.
    #
    # @param verison [String] Build version to look for.
    #
    # @return [String] Job number for the travis build.
    def wait_for_build(version)
      job_number = nil
      attempts = 0
      loop do
        # Give travis some time to start the build.
        attempts += 1
        sleep 10

        # Attempt to find the build. Rescue and re-attempt if the build can not
        # be found on travis yet.
        begin
          build_out = sh_out("bundle exec travis show #{@cli_args} #{version}")
        rescue RuntimeError => e
          next unless attempts >= MAX_BUILD_FIND_ATTEMPTS
          raise e
        end

        unless (job_number = build_out.match(/^#(\d+\.\d+) .+BUILD=1.+/)[1])
          next unless attempts >= MAX_BUILD_FIND_ATTEMPTS
          raise "Build for #{version} not found.\n#{build_out}"
        end

        # If we've reached this point then everything went smoothly and we can
        # exit the loop.
        break
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
