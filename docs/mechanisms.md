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

Supported DeploymentMechanisms:
- CodeDeploy

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

Supported ArtifactRepositories:
- S3

### S3Bucket

To create a new S3Bucket ArtifactRepository:
```ruby
class MyApplication < Moonshot::CLI
  self.artifact_repository = S3Bucket.new('my-bucket-name')
end
```

The store action will simply upload the file using the S3 PutObject API call.
The local environment must be configured with appropriate credentials.
