# BuildMechanism

## Script

The Script BuildMechanism will execute a local shell script, with certain
expectations. The script will run with some environment variables:

- `VERSION`: The named version string passed to `build-version`.
- `OUTPUT_FILE`: The file that the script is expected to produce.

If the file is not created by the build script, deployment will fail. Otherwise,
the output file will be uploaded using the ArtifactRepository.

Sample Usage
```ruby
#!/usr/bin/env ruby

require 'moonshot'

# Set up Moonshot tooling for our environment.
class MoonshotSampleApp < Moonshot::CLI
  self.build_mechanism = Script.new('bin/build.sh')
...
```

## Github Release

A build mechanism that creates a tag and GitHub release. Could be used to delegate other building steps after GitHub release is created.

Sample Usage

```ruby
#!/usr/bin/env ruby

require 'moonshot'

# Set up Moonshot tooling for our environment.
class MoonshotSampleApp < Moonshot::CLI
	wait_for_travis_mechanism = TravisDeploy.new("acquia/moonshot", true)
  self.build_mechanism = GithubRelease.new(wait_for_travis_mechanism)
...
```

## Travis Deploy

The Travis Build Mechanism waits for Travis-CI to finish building a job matching the VERSION (see above) and the output of the travis job has to be 'BUILD=1'. Can be used to make sure that the travis job for the repository for that version actually finished before the deployment step can be executed.

Sample Usage
```ruby
#!/usr/bin/env ruby

require 'moonshot'

# Set up Moonshot tooling for our environment.
class MoonshotSampleApp < Moonshot::CLI
  # First argument is the repository as known by travis.
  # Second argument is wether or not you are using travis pro.
  self.build_mechanism = TravisDeploy.new("acquia/moonshot", pro: true)
...
```

## Version Proxy

@Todo Document and clarify the use-case of the Version Proxy.
