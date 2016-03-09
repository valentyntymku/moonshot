# Moonshot
_Because releasing services shouldn't be a moonshot._

Moonshot is a Ruby gem for provisioning environments in AWS using a CLI.
The environments are centered around a single CloudFormation stack and supported
by pluggable systems:
- A DeploymentMechanism controls releasing code.
- A BuildMechanism creates a release artifact.
- A ArtifactRepository stores the release artifacts.

Supported DeploymentMechanisms:
- CodeDeploy

Supported ArtifactRepositories:
- S3

# Design Goals

These are core ideas to the creation of this project. Not all are met to the
level we'd like (e.g. CloudFormation isn't much of a Choice currently), but we
should aspire to meet them with each iteration.

- Simplicity: It shouldn't take more than a few hours to understand what your
  release tooling does.
- Choice: As much as possible, each component should be pluggable and omittable,
  so teams are free to use what works best for them.
- Verbosity: The output of core Moonshot code should explain in detail what
  changes are being made, so knowledge is shared and not abstracted.

# Configuring an AWS account

## CodeDeploy Role

Create a role called CodeDeployRole with the AWSCodeDeployRole policy

```
aws iam create-role --role-name CodeDeployRole --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Sid":"","Effect":"Allow","Principal":{"Service":["codedeploy.amazonaws.com"]},"Action":"sts:AssumeRole"}]}'
aws iam attach-role-policy --role-name CodeDeployRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole
```

# Basic Usage

The base class is a subclass of Thor, so you can extend it using all the normal
Thor stuff. Here's a really basic example using all the defaults:

```ruby
#!/usr/bin/env ruby

require 'moonshot'

# Set up Moonshot tooling for our environment.
class MyService < Moonshot::CLI
  self.application_name = 'my-service'
  self.artifact_repository = S3Bucket.new('my-service-builds')
  self.build_mechanism = Script.new('build/script.sh')
  self.deployment_mechanism = CodeDeploy.new(asg: 'AutoScalingGroup')

  desc 'my-custom-function'
  def my_custom_function
    puts "<:3)~~ eek! a mouse!"
  end
end

begin
  MyService.start
rescue => e
  warn "Uncaught exception: #{e.class}: #{e.message}"
  warn "at: #{e.backtrace.first}"
  exit(1)
end
```

This example assumes:
- You have a CloudFormation JSON template in "cloud_formation/my-service.json".
- You have an S3 bucket called "my-service-builds".
- You have a script in "script/build.sh" that will build a tarball output.tar.gz.
- You have a working CodeDeploy setup, including the CodeDeployRole.
- You have some need to display an ASCII mouse to the terminal with your release
  tooling.

If all that is true, you can now deploy your software to a new stack with:
```
$ ./bin/environment create
```

By default, you'll get a development environment named `my-service-dev-giraffe`,
where `giraffe` is your username. If you want to provision test or production
named environment, use:
```
$ ./bin/environment create -n my-service-staging
$ ./bin/environment create -n my-service-production
```

By default, create launches the stack and deploys code. If you want to only
create the stack and not deploy code, use:
```
$ ./bin/environment create --no-deploy
```

If you make changes to your application and want to release a development build
to your stack, run:
```
$ ./bin/environment deploy-code
```

To build a "named build" for releasing through test and production environments,
use:
```
$ ./bin/environment build-version v0.1.0
$ ./bin/environment deploy-version v0.1.0 -n <environment-name>
```

We recommend using a CI system like Jenkins to perform those activities, for
consistency.

# Including Moonshot-based tooling in your project

You'll want to build a tool using the template in Basic Usage as a starting point,
then grab a **release build**, either by using git directly from Bundler, or
including the gem directly in your `vendor/cache` directory.

# Stack Parameter overrides

One of the challenges we faced using CloudFormation was being consistent about
setting stack parameters as you make requests. We settled on a strategy that
keeps all per-environment tunings in the source repository acting as both a
safety net and documentation of existing environments. Here's how it works:

When a stack update is performed, a *parameter overrides file* is checked in
`cloud_formation/parameters/environment-name.yml`. This file is YAML formatted
and takes a hash of stack parameter names and values, for example:
```yaml
---
AsgDesiredCap: 12
AsgMaxCap: 15
ELBCertificate: iam::something:star_example_com
```

If a file exists, it's used every time a CloudFormation change request is sent,
so no configuration can revert back to defaults through this tool. It's highly
recommended that you add these files back to source control as soon as possible
and be in the habit of pulling latest changes before applying any infrastructure
updates.

# Built-In Mechanisms

## BuildMechanism

### Script

The Script BuildMechanism will execute a local shell script, with certain
expectations. The script will run with some environment variables:

- `VERSION`: The named version string passed to `build-version`.
- `OUTPUT_FILE`: The file that the script is expected to produce.

If the file is not created by the build script, deployment will fail. Otherwise,
the output file will be uploaded using the ArtifactRepository.

## DeploymentMechanism

### CodeDeploy

The CodeDeploy DeploymentMechanism will create a CodeDeploy Application and
Deployment Group matching the application name. The created Deployment Group
will point at the logical resource id provided to the constructor (e.g.
`CodeDeploy.new(asg: 'MyAutoScalingGroup')`). During the `deploy-code` action,
the ArtifactRepository is checked for compatibility with CodeDeploy. Currently
only the S3Bucket is supported, though CodeDeploy itself supports deploying from
a git source.

Assumptions made by the CodeDeploy mechanism:
- You are using an S3Bucket ArtifactRepository.
- You want to deploy using the OneAtATime method.
- Your build artifact contains an appspec.yml file.

For more information about CodeDeploy, see the [AWS Documentation][1].

[1]: http://docs.aws.amazon.com/codedeploy/latest/userguide/welcome.html

## ArtifactRepository

### S3Bucket

To create a new S3Bucket ArtifactRepository:
```ruby
class MyApplication < Moonshot::CLI
  self.artifact_repository = S3Bucket.new('my-bucket-name')
end
```

The store action will simply upload the file using the S3 PutObject API call.
The local environment must be configured with appropriate credentials.
