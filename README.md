# Moonshot [![Build Status](https://travis-ci.org/acquia/moonshot.svg?branch=master)](https://travis-ci.org/acquia/moonshot)
_Because releasing services shouldn't be a moonshot._

Moonshot is a tool for provisioning infrastructure and applications in AWS with CloudFormation and CodeDeploy using a CLI. Its main goal is to make it possible to control the deployment in a programmable and extensible way so that there is less room for human errors in the AWS console when creating and updating cloudformation templates but also deploying new software using CodeDeploy.

The software is relying on a single CloudFormation stack and supported by pluggable systems:

- A DeploymentMechanism controls releasing code.
- A BuildMechanism creates a release artifact.
- A ArtifactRepository stores the release artifacts.

Read the documentation at __insert_link_here_to_read_the_docs__ or see the docs folder.

Discussions and support: Please see the issues in the current repository
