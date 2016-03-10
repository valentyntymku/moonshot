# Moonshot [![Documentation Status](https://readthedocs.org/projects/moonshot/badge/?version=latest)](http://moonshot.readthedocs.org/en/latest/?badge=latest)[![Build Status](https://travis-ci.org/acquia/moonshot.svg?branch=master)](https://travis-ci.org/acquia/moonshot)[![Test Coverage](https://codeclimate.com/github/acquia/moonshot/badges/coverage.svg)](https://codeclimate.com/github/acquia/moonshot/coverage)[![Code Climate](https://codeclimate.com/github/acquia/moonshot/badges/gpa.svg)](https://codeclimate.com/github/acquia/moonshot)
_Because releasing services shouldn't be a moonshot._

Moonshot is a tool for provisioning infrastructure and applications in AWS with CloudFormation and CodeDeploy using a CLI. Its main goal is to make it possible to control the deployment in a programmable and extensible way so that there is less room for human errors in the AWS console when creating and updating cloudformation templates but also deploying new software using CodeDeploy.

The software is relying on a single CloudFormation stack and supported by pluggable systems:

- A DeploymentMechanism controls releasing code.
- A BuildMechanism creates a release artifact.
- A ArtifactRepository stores the release artifacts.

You can read [nicely formatted documentation][1] on how Moonshot works and how to extend it. We also want to [help you contribute and answer all your questions][2] on how Moonshot is maintained.

## Super Basic Installation Instructions

Seriously, go and see our [nicely formatted documentation][1] for more details.
Add this line to your application's Gemfile:

    gem 'moonshot'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install moonshot

[1]: http://moonshot.readthedocs.org/en/latest/
[2]: http://moonshot.readthedocs.org/en/latest/about/contribute
