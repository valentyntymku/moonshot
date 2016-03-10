
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
